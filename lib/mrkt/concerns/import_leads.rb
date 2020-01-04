module Mrkt
  module ImportLeads
    def import_lead(file, format = 'csv', lookup_field: nil, list_id: nil, partition_name: nil)
      params = {
        format: format,
        file: ::Faraday::UploadIO.new(file, 'text/csv')
      }

      optional = {
        lookupField: lookup_field,
        listId: list_id,
        partitionName: partition_name
      }

      post('/bulk/v1/leads.json', params, optional)
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
