require 'mrkt/faraday_middleware'

module Mrkt
  module Connection
    def connection
      @connection ||= init_connection
    end

    def init_connection
      Faraday.new(url: "https://#{@host}") do |conn|
        conn.request :multipart
        conn.request :url_encoded

        conn.response :logger, @logger, (@log_options || {}) if @debug
        conn.response :mkto, content_type: /\bjson$/

        conn.options.timeout = @options[:read_timeout] if @options.key?(:read_timeout)
        conn.options.open_timeout = @options[:open_timeout] if @options.key?(:open_timeout)

        conn.adapter @options.fetch(:adapter, Faraday.default_adapter)
      end
    end
  end
end
