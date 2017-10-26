module Mrkt
  module ImportCustomObjects
    def import_custom_objects(file, api_name, format = 'csv')
      params = {
        format: format,
        file: Faraday::UploadIO.new(file, 'text/csv')
      }

      post('/bulk/v1/customobjects/#{api_name}/import.json', params)
    end

    def import_custom_objects_status(id, api_name)
      get("/bulk/v1/customobjects/#{api_name}/import/#{id}/status.json")
    end

    def import_custom_objects_failures(id, api_name)
      get("/bulk/v1/customobjects/#{api_name}/import/#{id}/failures.json")
    end

    def import_custom_objects_warnings(id, api_name)
      get("/bulk/v1/customobjects/#{api_name}/import/#{id}/warnings.json")
    end
  end
end
