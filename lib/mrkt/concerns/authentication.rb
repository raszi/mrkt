module Mrkt
  module Authentication
    def authenticate!
      return if authenticated?

      authenticate

      retry_authentication if !authenticated? && @retry_authentication

      raise Mrkt::Errors::AuthorizationError, 'Client not authenticated' unless authenticated?
    end

    def authenticated?
      @token && valid_token?
    end

    def valid_token?
      @valid_until && Time.now < @valid_until
    end

    def retry_authentication
      @retry_authentication_count.times do
        sleep(@retry_authentication_wait_seconds) if @retry_authentication_wait_seconds > 0
        authenticate

        break if authenticated?
      end
    end

    def authenticate
      connection.get('/identity/oauth/token', authentication_params).tap do |response|
        data = response.body

        @token = data.fetch(:access_token)
        @token_type = data.fetch(:token_type)
        @valid_until = Time.now + data.fetch(:expires_in)
        @scope = data.fetch(:scope)
      end
    end

    def authentication_params
      {
        grant_type: 'client_credentials',
        client_id: @client_id,
        client_secret: @client_secret
      }
    end

    def add_authorization(req)
      req.headers[:authorization] = "Bearer #{@token}"
    end
  end
end
