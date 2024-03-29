require 'faraday/response/json'

module Mrkt
  module FaradayMiddleware
    class Response < ::Faraday::Response::Json
      private

      def process_response(env)
        super

        data = env[:body]

        raise Mrkt::Errors::EmptyResponse if data.nil?
        raise Mrkt::Errors::Error, data[:error_description] if data.key?(:error)

        handle_errors!(data[:errors]) unless data.fetch(:success, true)
      end

      def handle_errors!(errors)
        error = errors.first

        raise Mrkt::Errors::Unknown if error.nil?
        raise Mrkt::Errors.find_by_response_code(error[:code].to_i), error[:message]
      end
    end
  end
end
