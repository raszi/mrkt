module Mrkt
  module CrudProgramMembers
    def describe_program_members
      get('/rest/v1/programs/members/describe.json')
    end
  end
end
