module Mrkt
  module CrudHelpers
    def json_payload(req, payload)
      req.headers[:content_type] = 'application/json'
      req.body = JSON.generate(payload)
    end
  end
end
