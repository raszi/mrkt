module Mrkt
  module CrudCustomObjects
    def get_list_of_custom_objects(names = nil)
      params = {}
      params[:names] = names if names

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

        optional = {
          fields: fields,
          nextPageToken: next_page_token,
          batchSize: batch_size
        }

        merge_params(params, optional)
      end
    end
  end
end
