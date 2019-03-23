module Mrkt
  module CrudPrograms
    def browse_programs(offset: nil, max_return: nil, status: nil)
      optional = {
        offset: offset,
        maxReturn: max_return,
        status: status
      }

      get('/rest/asset/v1/programs.json', {}, optional)
    end

    def get_program_by_id(id)
      get("/rest/asset/v1/program/#{id}.json")
    end
  end
end
