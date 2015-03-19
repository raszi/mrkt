require_relative 'mkto_rest/version'
require_relative 'mkto_rest/http_utils'
require_relative 'mkto_rest/lead'
require_relative 'mkto_rest/errors'
require 'json'

module MktoRest
  class Client
    attr_reader :host, :client_id, :client_secret, :token, :expires_in
    attr_reader :valid_until, :token_type, :scope, :last_request_id

    def initialize(options = {})
      @host = options[:host]
      @client_id = options[:client_id]
      @client_secret = options[:client_secret]
      @options = {}
      @token = ''
    end

    # sets / unsets debug mode
    def debug=(bool)
      MktoRest::HttpUtils.debug = bool
    end

    def authenticated?
      !@token.empty?
    end

    # used for testing only
    def __auth(token)
      @token = token
    end

    # \options:
    #    open_timeout - http open timeout
    #    read_timeout - http read timeout
    def authenticate(options = {})
      args = {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_secret: @client_secret
      }
      @options = options
      body = MktoRest::HttpUtils.get("https://#{@host}/identity/oauth/token", args, @options)
      fail 'response empty.' if body.nil?
      data = JSON.parse(body, symbolize_names: true)
      fail data[:error_description] if data[:error]
      @token = data[:access_token]
      @token_type = data[:token_type]
      @expires_in = data[:expires_in]
      @valid_until = Time.now + data[:expires_in]
      @scope = data[:scope]
    end

    def get_leads(filtr, values = [], fields = [], &block)
      authenticate unless authenticated?
      # values can be a string or an array
      values = values.split unless values.is_a? Array
      args = {
        access_token: @token,
        filterType: filtr.to_s,
        filterValues: values.join(',')
      }
      args[:fields] = fields.join(',') unless fields.empty?
      body = MktoRest::HttpUtils.get("https://#{@host}/rest/v1/leads.json", args, @options)
      fail 'response empty.' if body.nil?
      data = JSON.parse(body, symbolize_names: true)
      @last_request_id = data[:requestId]
      fail data[:errors].to_s if data[:success] == false
      data[:result].each_with_object([]) do |lead_attributes, leads|
        l = Lead.new(self, lead_attributes)
        block.call(l) unless block.nil?
        leads << l
      end unless data[:result].empty?
    end

    def create_leads(leads, action = 'createOnly', partition = nil)
      # leads is an array of objects like:
      #   {
      #    "email":"kjashaedd-3@klooblept.com",
      #    "firstName":"Kataldar-3",
      #    "postalCode":"04828"
      #   }
      # maximium length of leads = 300

      data = {
        action: action,
        input: leads
      }
      data[:partitionName] = partition if partition

      post(data)
    end

    %i(email id).each do |sym|
      define_method("update_lead_by_#{sym}".to_sym) do |lookup_value, values|
        post(
          {
            action: 'updateOnly',
            lookupField: sym.to_s,
            input: [
              { sym => lookup_value }.merge(values)
            ]
          }
        )
      end
    end

    def associate_lead(id, cookie)
      authenticate unless authenticated?
      post(nil, "https://#{@host}/rest/v1/leads/#{id}/associate.json?#{URI.encode_www_form(cookie: cookie, access_token: @token)}")
    end

    def post(data, url = "https://#{@host}/rest/v1/leads.json")
      authenticate unless authenticated?
      fail 'client not authenticated.' unless authenticated?
      headers = { 'Authorization' => "Bearer #{@token}" }
      body = MktoRest::HttpUtils.post(url, headers, data.to_json, @options)
      data = JSON.parse(body, symbolize_names: true)
      handle_errors(data[:errors]) if data[:success] == false
      data
    end

    def handle_errors(errors)
      error = errors.first
      return if error.nil?
      raise MktoRest::Errors.find_by_response_code(error[:code].to_i), error[:message]
    end
  end
end
