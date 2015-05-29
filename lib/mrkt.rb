require 'mrkt/version'
require 'mrkt/errors'

require 'mrkt/concerns/connection'
require 'mrkt/concerns/authentication'
require 'mrkt/concerns/crud_leads'
require 'mrkt/concerns/import_leads'

module Mrkt
  class Client
    include Connection
    include Authentication
    include CrudLeads
    include ImportLeads

    attr_accessor :debug

    def initialize(options = {})
      @host = options.fetch(:host)

      @client_id = options.fetch(:client_id)
      @client_secret = options.fetch(:client_secret)

      @options = options
    end

    [:get, :post, :delete].each do |http_method|
      define_method(http_method) do |*args, &block|
        authenticate!

        path = args[0]
        payload = args[1] || {}

        resp = connection.send(http_method, path, payload) do |req|
          add_authorization(req)
          block.call(req) unless block.nil?
        end

        resp.body
      end
    end
  end
end
