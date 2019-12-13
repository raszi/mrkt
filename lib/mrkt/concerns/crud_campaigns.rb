module Mrkt
  module CrudCampaigns
    def request_campaign(id, lead_ids, tokens = [])
      post_json("/rest/v1/campaigns/#{id}/trigger.json") do
        {
          input: {
            leads: map_lead_ids(lead_ids),
            tokens: tokens
          }
        }
      end
    end
  end
end
