module Mrkt
  module ImportCustomObjects
    def import_custom_object(file, custom_object, format = 'csv')
      params = {
        format: format,
        file: Faraday::UploadIO.new(file, 'text/csv')
      }

      post("/bulk/v1/customobjects/#{custom_object}/import.json", params)
    end

    def import_custom_object_status(id, custom_object)
      get("/bulk/v1/customobjects/#{custom_object}/import/#{id}/status.json")
    end

    def import_custom_object_failures(id, custom_object)
      get("/bulk/v1/customobjects/#{custom_object}/import/#{id}/failures.json")
    end

    def import_custom_object_warnings(id, custom_object)
      get("/bulk/v1/customobjects/#{custom_object}/import/#{id}/warnings.json")
    end
  end
end
