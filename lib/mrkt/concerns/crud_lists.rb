module Mrkt
  module CrudLists
    def get_leads_by_list(list_id, fields: nil, batch_size: nil, next_page_token: nil)
      params = {}
      params[:fields] = fields if fields
      params[:batchSize] = batch_size if batch_size
      params[:nextPageToken] = next_page_token if next_page_token

      get("/rest/v1/list/#{list_id}/leads.json", params)
    end

    def get_list(list_id)
      get("/rest/v1/lists/#{list_id}.json")
    end

    def get_lists(id: nil, name: nil, program_name: nil, workspace_name: nil, batch_size: nil, next_page_token: nil)
      params = {}
      params[:id] if id
      params[:name] = name if name
      params[:programName] = program_name if program_name
      params[:workspaceName] = workspace_name if workspace_name
      params[:batchSize] = batch_size if batch_size
      params[:nextPageToken] = next_page_token if next_page_token

      get("/rest/v1/lists.json", params)
    end

    def add_leads_to_list(list_id, lead_ids)
      post("/rest/v1/lists/#{list_id}/leads.json") do |req|
        params = {
          input: map_lead_ids(lead_ids)
        }

        json_payload(req, params)
      end
    end
  end
end
