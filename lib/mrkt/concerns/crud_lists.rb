module Mrkt
  module CrudLists
    def get_leads_by_list(list_id, fields: nil, batch_size: nil, next_page_token: nil)
      optional = {
        fields: fields,
        batchSize: batch_size,
        nextPageToken: next_page_token
      }

      get("/rest/v1/list/#{list_id}/leads.json", {}, optional)
    end

    def add_leads_to_list(list_id, lead_ids)
      post_json("/rest/v1/lists/#{list_id}/leads.json") do
        { input: map_lead_ids(lead_ids) }
      end
    end

    def remove_leads_from_list(list_id, lead_ids)
      delete("/rest/v1/lists/#{list_id}/leads.json") do |req|
        json_payload(req, input: map_lead_ids(lead_ids))
      end
    end
  end
end
