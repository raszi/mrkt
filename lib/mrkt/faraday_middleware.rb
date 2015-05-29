require 'faraday'

module Mrkt
  module FaradayMiddleware
    autoload :Response, 'mrkt/faraday_middleware/response'
  end

  if Faraday::Middleware.respond_to? :register_middleware
    Faraday::Response.register_middleware :mkto => lambda { Mrkt::FaradayMiddleware::Response }
  end
end
