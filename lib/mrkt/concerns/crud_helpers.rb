module Mrkt
  module CrudHelpers
    def map_lead_ids(lead_ids)
      lead_ids.map { |id| { id: id } }
    end

    def json_payload(req, payload)
      req.headers[:content_type] = 'application/json'
      req.body = JSON.generate(payload)
    end
  end
end
