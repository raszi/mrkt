module Mrkt
  module Authentication
    def authenticate!
      authenticate unless authenticated?
      fail Mrkt::Errors::AuthorizationError, 'Client not authenticated' unless authenticated?
    end

    def authenticated?
      @token && valid_token?
    end

    def valid_token?
      @valid_until && Time.now < @valid_until
    end

    def authenticate
      params = {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_secret: @client_secret
      }

      connection.get('/identity/oauth/token', params).tap do |response|
        data = response.body

        @token = data.fetch(:access_token)
        @token_type = data.fetch(:token_type)
        @valid_until = Time.now + data.fetch(:expires_in)
        @scope = data.fetch(:scope)
      end
    end

    def add_authorization(req)
      req.headers[:authorization] = "Bearer #{@token}"
    end
  end
end
