module Mrkt
  module CrudPrograms
    def browse_programs(offset: nil, max_return: nil, status: nil)
      params = {}
      params[:offset] = offset if offset
      params[:maxReturn] = max_return if max_return
      params[:status] = status if status

      get('/rest/asset/v1/programs.json', params)
    end
  end
end
