require 'faraday'

module Mrkt
  module FaradayMiddleware
    autoload :Response, 'mrkt/faraday_middleware/response'
    autoload :ExceptionalResponse, 'mrkt/faraday_middleware/exceptional_response'
  end

  if Faraday::Middleware.respond_to? :register_middleware
    Faraday::Response.register_middleware mkto: -> { Mrkt::FaradayMiddleware::Response }
    Faraday::Response.register_middleware mkto_exceptional_response: -> { Mrkt::FaradayMiddleware::ExceptionalResponse }
  end
end
