require 'mkto_rest/faraday_middleware'

module MktoRest
  module Connection
    def connection
      @connection ||= init_connection
    end

    def init_connection
      Faraday.new(url: "https://#{@host}") do |conn|
        # Faraday.new(url: "http://localhost") do |conn|
        conn.request :multipart
        conn.request :url_encoded
        # conn.request :mkto, client_id, client_secret

        conn.response :logger if @debug
        conn.response :mkto, content_type: /\bjson$/

        conn.options.timeout = @options[:read_timeout] if @options.key?(:read_timeout)
        conn.options.open_timeout = @options[:open_timeout] if @options.key?(:open_timeout)

        conn.adapter Faraday.default_adapter
      end
    end
  end
end
