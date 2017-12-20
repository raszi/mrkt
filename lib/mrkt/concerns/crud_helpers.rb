module Mrkt
  module CrudHelpers
    def map_lead_ids(lead_ids)
      lead_ids.map { |id| { id: id } }
    end

    def post_json(url)
      post(url) do |req|
        payload = block_given? ? yield(req) : {}
        json_payload(req, payload)
      end
    end

    def json_payload(req, payload)
      req.headers[:content_type] = 'application/json'
      req.body = JSON.generate(payload)
    end
  end
end
