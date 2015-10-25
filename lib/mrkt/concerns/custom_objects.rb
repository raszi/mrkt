module Mrkt
  module CustomObjects
    def get_list_of_custom_objects(object_names)
      params = {
        :names => object_names.join(',')
      }

      get('/rest/v1/customobjects.json', params)
    end

    def describe_custom_object(object_name)
      get("/rest/v1/customobjects/#{object_name}/describe.json")
    end

    def createupdate_custom_objects(object_name, objects, options = {})
      post("/rest/v1/customobjects/#{object_name}.json") do |req|
        params = {
          :input => objects,
          :actions => options.fetch(:actions, 'createOrUpdate'),
          :dedupeBy => options.fetch(:dedupe_by, 'dedupeFields')
        }

        json_payload(req, params)
      end
    end

    def delete_custom_objects(object_name, search_values, options = {})
      post("/rest/v1/customobjects/#{object_name}/delete.json") do |req|
        params = {
          :input => search_values,
          :deleteBy => options.fetch(:delete_by, 'dedupeFields')
        }

        json_payload(req, params)
      end
    end

    def get_custom_objects(object_name, filter_type, options = {})
      filter_values = options.fetch(:filter_values, nil)
      fields = options.fetch(:fields, nil)
      next_page_token = options.fetch(:next_page_token, nil)
      batch_size = options.fetch(:batch_size, nil)

      params = {
        :filterType => filter_type,
      }

      params[:filterValues] = filter_values.join(',') if filter_values
      params[:fields] = fields if fields
      params[:nextPageToken] = next_page_token if next_page_token
      params[:batchSize] = batch_size if batch_size

      get("/rest/v1/customobjects/#{object_name}.json", params)
    end
  end
end
