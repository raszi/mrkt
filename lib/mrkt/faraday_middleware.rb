require 'mrkt/faraday_middleware/response'

module Mrkt
  if ::Faraday::Middleware.respond_to?(:register_middleware)
    ::Faraday::Response.register_middleware(mkto: Mrkt::FaradayMiddleware::Response)
  end
end
