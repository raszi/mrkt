require "mkto_rest/version"
require "mkto_rest/http_utils"
require "mkto_rest/lead"
require "json"

module MktoRest
  class Client
    attr_reader :host, :client_id, :client_secret, :token, :valid_until, :token_type, :scope, :last_request_id
    def initialize(host, client_id, client_secret)
      @host = host
      @client_id = client_id
      @client_secret = client_secret
    end

    #sets / unsets debug mode
    def debug=(bool)
      MktoRest::HttpUtils.debug = bool
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
      data = JSON.parse(body, { symbolize_names: true })
      raise RuntimeError.new(data[:error_description]) if data[:error]
      @token = data[:access_token]
      @token_type = data[:token_type]
      @valid_until = Time.now + data[:expires_in] 
      @scope = data[:scope]
    end

    def get_leads(filtr, values = [], fields = [])
      raise RuntimeError.new("client not authenticated.") unless @token
      # values can be a string or an array
      values = values.split() unless values.is_a? Array
      args = {
        access_token: @token,
        filterType: filtr.to_s,
        filterValues: values.join(','),
      }
      args[:fields] = fields.join(',') unless fields.empty?
      body = MktoRest::HttpUtils.get("https://#{@host}/rest/v1/leads.json", args, @options)
      data = JSON.parse(body, { symbolize_names: true })
      @last_request_id = data[:requestId]
      raise RuntimeError.new(data[:errors].to_s) if data[:success] == false
      leads = []
      data[:result].each do |lead_attributes|
        yield Lead.new(self, lead_attributes) 
      end unless data[:result].empty?
    end

    def update_lead_by_email(email, values)
      data = {
        action: "updateOnly",
        lookupField: 'email',
        # bug prevents the use of this field lookupField: "id", 
        input: [
          {
            email: email,
            # bug prevents the use of id id: id,
          }.merge(values)
        ]
      }.to_json
      post data
    end
    def update_lead_by_id(id, values)
      data = {
        action: "updateOnly",
        #lookupField: 'id',
        # bug prevents the use of this field lookupField: "id", 
        input: [
          {
            #email: email,
            id: id
            # bug prevents the use of id id: id,
          }.merge(values)
        ]
      }.to_json
      post data
    end

    def post(data)
      headers = {
        "Authorization" => "Bearer #{@token}"
      }
      
      body = MktoRest::HttpUtils.post("https://#{@host}/rest/v1/leads.json" + "?", headers, data, @options)
      data = JSON.parse(body, { symbolize_names: true })
      raise RuntimeError.new(data[:errors].to_s) if data[:success] == false
      data
    end

  end


end
