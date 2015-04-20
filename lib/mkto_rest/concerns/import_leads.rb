module MktoRest
  module ImportLeads
    def import_lead(file, format = 'csv', lookup_field = nil, list_id: nil, partition_name: nil)
      params = {
        format: format,
        file: Faraday::UploadIO.new(file, 'text/csv')
      }
      params[:lookupField] = lookup_field if lookup_field
      params[:listId] = list_id if list_id
      params[:partitionName] = partition_name if partition_name

      post('/bulk/v1/leads.json', params)
    end

    def import_lead_status(id)
      get("/bulk/v1/leads/batch/#{id}.json")
    end

    def import_lead_failures(id)
      get("/bulk/v1/leads/batch/#{id}/failures.json")
    end

    def import_lead_warnings(id)
      get("/bulk/v1/leads/batch/#{id}/warnings.json")
    end
  end
end
