require 'mkto_rest/version'
require 'mkto_rest/errors'

require 'mkto_rest/concerns/connection'
require 'mkto_rest/concerns/authentication'
require 'mkto_rest/concerns/crud_leads'
require 'mkto_rest/concerns/import_leads'

module MktoRest
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

    %i(get post delete).each do |http_method|
      define_method(http_method) do |path, payload = {}, &block|
        authenticate!

        connection.send(http_method, path, payload) do |req|
          add_authorization(req)
          block.call(req) unless block.nil?
        end
      end
    end
  end
end
