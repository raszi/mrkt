module Mrkt
  module Activities
    def get_activity_types
      get("/rest/v1/activities/types.json")
    end

    def get_activities(page_token, date, activity_type_ids)
      params = { nextPageToken: page_token, activityTypeIds: activity_type_ids }
      get("/rest/v1/activities.json", params)
    end
  end
end
