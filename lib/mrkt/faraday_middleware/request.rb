require 'faraday_middleware'

module Mrkt
  module FaradayMiddleware
    class Request < Faraday::Middleware
      def initialize(app, client_id, client_secret)
        super(app)

        @client_id = client_id
        @client_secret = client_secret
      end

      def call(env)
        authenticate(env) unless authenticated? || env[:authentication]

        env.request_headers[:authorization] = "Bearer #{@token}"
        @app.call(env)
      end

      def authenticated?
        @token && token_valid?
      end

      def token_valid?
        @valid_until && Time.now < @valid_until
      end

      def authenticate(orig_env)
        env = Faraday::Env.from(orig_env)

        body = env[:body]
        params = Faraday::Utils::ParamsHash.new
        params.update(
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret
        )
        env[:authentication] = true
        env[:method] = :get

        env[:url] = env[:url].dup
        env[:url].path = '/identity/oauth/token'
        env[:url].query = params.to_query

        orig_env[:body] = body

        response = @app.call(env)
        data = response.body

        @token = data[:access_token]
        @token_type = data[:token_type]
        @expires_in = data[:expires_in]
        @valid_until = Time.now + data[:expires_in]
        @scope = data[:scope]
      end
    end
  end
end
