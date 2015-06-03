module Mrkt
  module ImportLeads
    def import_lead(file, options = {})
      params = {
        :format => options.fetch(:format, 'csv'),
        :file => Faraday::UploadIO.new(file, 'text/csv')
      }

      params[:lookupField] = options[:lookup_field]
      params[:listId] = options[:list_id]
      params[:partitionName] = options[:partition_name]

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
