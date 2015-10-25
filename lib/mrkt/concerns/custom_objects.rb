module Mrkt
  module CustomObjects
    def get_list_of_custom_objects(object_names)
      params = {
        names: object_names.join(',')
      }

      get('/rest/v1/customobjects.json', params)
    end

    def describe_custom_object(object_name)
      get("/rest/v1/customobjects/#{object_name}/describe.json")
    end

    def createupdate_custom_objects(object_name, objects, action: 'createOrUpdate', dedupe_by: 'dedupeFields')
      post("/rest/v1/customobjects/#{object_name}.json") do |req|
        params = {
          input: objects,
          action: action,
          dedupeBy: dedupe_by
        }

        json_payload(req, params)
      end
    end

    def delete_custom_objects(object_name, search_values, delete_by: 'dedupeFields')
      post("/rest/v1/customobjects/#{object_name}/delete.json") do |req|
        params = {
          input: search_values,
          deleteBy: delete_by
        }

        json_payload(req, params)
      end
    end

    def get_custom_objects(object_name, filter_type, filter_values: nil, fields: nil, next_page_token: nil, batch_size: nil)
      post("/rest/v1/customobjects/#{object_name}.json") do |req|
        params = {
          filterType: filter_type,
          _method: 'GET'
        }

        params[:filterValues] = filter_values if filter_values
        params[:fields] = fields if fields
        params[:nextPageToken] = next_page_token if next_page_token
        params[:batchSize] = batch_size if batch_size

        json_payload(req, params)
      end
    end
  end
end
