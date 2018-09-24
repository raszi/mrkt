module Mrkt
  module CrudCampaigns
    def request_campaign(id, lead_ids, tokens = {})
      post_json("/rest/v1/campaigns/#{id}/trigger.json") do
        {
          input: {
            leads: map_lead_ids(lead_ids),
            tokens: tokens
          }
        }
      end
    end

    def schedule_campaign(id, run_at = nil)
      post_json("/rest/v1/campaigns/#{id}/schedule.json") do
        {
          input: {
            runAt: run_at
          }
        }
      end
    end
  end
end
