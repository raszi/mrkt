require 'faraday'

module MktoRest
  module FaradayMiddleware
    autoload :Response, 'mkto_rest/faraday_middleware/response'
  end

  if Faraday::Middleware.respond_to? :register_middleware
    Faraday::Response.register_middleware mkto: -> { MktoRest::FaradayMiddleware::Response }
  end
end
