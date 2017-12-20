module Mrkt
  module CrudCustomObjects
    def get_list_of_custom_objects(names = nil)
      params = {}
      params[:names] = names.join(',') if names

      get('/rest/v1/customobjects.json', params)
    end

    def describe_custom_object(name)
      raise Mrkt::Errors::Unknown unless name

      get("/rest/v1/customobjects/#{name}/describe.json")
    end

    def createupdate_custom_objects(name, input, action: 'createOrUpdate', dedupe_by: 'dedupeFields')
      post_json("/rest/v1/customobjects/#{name}.json") do
        {
          input: input,
          action: action,
          dedupeBy: dedupe_by
        }
      end
    end

    def delete_custom_objects(name, input, delete_by: 'dedupeFields')
      post_json("/rest/v1/customobjects/#{name}/delete.json") do
        {
          input: input,
          deleteBy: delete_by
        }
      end
    end

    def get_custom_objects(name, input, filter_type: 'dedupeFields', fields: nil, next_page_token: nil, batch_size: nil)
      post_json("/rest/v1/customobjects/#{name}.json?_method=GET") do
        params = {
          input: input,
          filterType: filter_type
        }

        params[:fields] = fields if fields
        params[:nextPageToken] = next_page_token if next_page_token
        params[:batchSize] = batch_size if batch_size

        params
      end
    end
  end
end
