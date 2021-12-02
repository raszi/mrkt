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
  end
end
