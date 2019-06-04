require 'mrkt/version'
require 'mrkt/errors'

require 'mrkt/concerns/connection'
require 'mrkt/concerns/authentication'
require 'mrkt/concerns/crud_helpers'
require 'mrkt/concerns/crud_activities'
require 'mrkt/concerns/crud_campaigns'
require 'mrkt/concerns/crud_leads'
require 'mrkt/concerns/crud_lists'
require 'mrkt/concerns/import_leads'
require 'mrkt/concerns/import_custom_objects'
require 'mrkt/concerns/crud_custom_objects'
require 'mrkt/concerns/crud_custom_activities'
require 'mrkt/concerns/crud_programs'
require 'mrkt/concerns/crud_asset_static_lists'
require 'mrkt/concerns/crud_asset_folders'

module Mrkt
  class Client
    include Connection
    include Authentication
    include CrudHelpers
    include CrudActivities
    include CrudCampaigns
    include CrudLeads
    include CrudLists
    include ImportLeads
    include ImportCustomObjects
    include CrudCustomObjects
    include CrudCustomActivities
    include CrudPrograms
    include CrudAssetStaticLists
    include CrudAssetFolders

    attr_accessor :debug

    def initialize(options = {})
      @host = options.fetch(:host)

      @client_id = options.fetch(:client_id)
      @client_secret = options.fetch(:client_secret)
      @partner_id = options[:partner_id]

      @retry_authentication = options.fetch(:retry_authentication, false)
      @retry_authentication_count = options.fetch(:retry_authentication_count, 3).to_i
      @retry_authentication_wait_seconds = options.fetch(:retry_authentication_wait_seconds, 0).to_i

      @debug = options[:debug]

      @logger = options[:logger]
      @log_options = options[:log_options]

      @options = options
    end

    def merge_params(params, optional)
      params.merge(optional.keep_if { |_key, value| value })
    end

    %i[get post delete].each do |http_method|
      define_method(http_method) do |path, params = {}, optional = {}, &block|
        authenticate!

        payload = merge_params(params, optional)

        resp = connection.send(http_method, path, payload) do |req|
          add_authorization(req)
          block&.call(req)
        end

        resp.body
      end
    end
  end
end
