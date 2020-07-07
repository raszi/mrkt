module Mrkt
  module FaradayMiddleware
    # A middleware to handle exceptional non-json responses.
    # In some cases, for example in trouble of marketo servers, we confirmed
    # there is possibility that servers could respond with non json response
    # unexpectedly.
    class ExceptionalResponse < Faraday::Response::Middleware
      ServerErrorStatuses = 400...600

      def on_complete(env)
        # Nothing to do by this handler if response content type is like json
        return if env[:response_headers]['Content-Type'] =~ /\bjson$/

        case env[:status]
        when ServerErrorStatuses
          raise Mrkt::Errors::Unknown, response_values(env)
        end
      end

      def response_values(env)
        {:status => env.status, :headers => env.response_headers, :body => env.body}
      end
    end
  end
end
