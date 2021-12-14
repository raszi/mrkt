module Mrkt
  module CrudProgramMembers
    def describe_program_members
      get('/rest/v1/programs/members/describe.json')
    end

    def createupdate_program_members(program_id, lead_ids, status)
      post_json("/rest/v1/programs/#{program_id}/members/status.json") do
        params = {
          statusName: status,
          input: lead_ids.map { |lead_id| { leadId: lead_id } }
        }
      end
    end

    def get_program_members(program_id, filter_type, filter_values, fields: nil, batch_size: nil, next_page_token: nil)
      params = {
        filterType: filter_type,
        filterValues: filter_values
      }

      optional = {
        fields: fields,
        batchSize: batch_size,
        nextPageToken: next_page_token
      }

      get("/rest/v1/programs/#{program_id}/members.json", params, optional)
    end
  end
end
