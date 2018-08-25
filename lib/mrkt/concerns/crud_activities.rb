module Mrkt
  module CrudActivities
    def get_activity_types
      get('/rest/v1/activities/types.json')
    end

    def get_paging_token(since_datetime)
      params = {
        sinceDatetime: since_datetime.iso8601
      }
      get('/rest/v1/activities/pagingtoken.json', params)
    end

    def get_activities(next_page_token, activity_type_ids: [], lead_ids: [])
      params = {
        nextPageToken: next_page_token
      }
      params[:activityTypeIds] = activity_type_ids.join(',') unless blank?(activity_type_ids)
      params[:leadIds] = lead_ids.join(',') unless blank?(lead_ids)
      get('/rest/v1/activities.json', params)
    end

    def get_deleted_leads(next_page_token)
      params = {
        nextPageToken: next_page_token
      }
      get('/rest/v1/activities/deletedleads.json', params)
    end

    private

    def blank?(value)
      !value || value == '' || value.empty?
    end
  end
end
