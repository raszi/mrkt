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
      @token = data[:access_token]
      @token_type = data[:token_type]
      @valid_until = Time.now + data[:expires_in] 
      @scope = data[:scope]
    end

    def get_leads(filtr, values = [], fields = [])
      raise Exception.new("not authenticated.") unless @token
      args = {
        access_token: @token,
        filterType: filtr.to_s,
        filterValues: values.join(','),
      }
      args[:fields] = fields.join(',') unless fields.empty?
      body = MktoRest::HttpUtils.get("https://#{@host}/rest/v1/leads.json", args, @options)
      data = JSON.parse(body, { symbolize_names: true })
      @last_request_id = data[:requestId]
      raise RuntimeError.new('API call failed.') if data[:success] == false
      leads = []
      data[:result].each do |lead_attributes|
        leads << Lead.new(lead_attributes) 
      end
      leads
    end

    def update_lead(id, values)
      
      data = {
        action: "updateOnly",
        input: [
          {
            id: id,
          }.merge(values)
        ]
      }.to_json

      headers = {
        "Authorization" => "Bearer #{@token}"
      }
      
      body = MktoRest::HttpUtils.post("https://#{@host}/rest/v1/leads.json" + "?", headers, data, @options)
      data = JSON.parse(body, { symbolize_names: true })
      p data
    end


  end


end
