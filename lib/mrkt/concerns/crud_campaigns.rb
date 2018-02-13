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
      if run_at.blank?
        run_at = 2.minutes.from_now.in_time_zone(-8).iso8601
      end
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
