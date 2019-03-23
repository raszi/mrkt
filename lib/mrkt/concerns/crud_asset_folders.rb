module Mrkt
  module CrudAssetFolders
    def create_folder(name, parent, description: nil)
      post('/rest/asset/v1/folders.json') do |req|
        params = {
          name: name,
          parent: JSON.generate(parent)
        }

        optional = {
          description: description
        }

        req.body = merge_params(params, optional)
      end
    end

    def get_folder_by_id(id, type: nil)
      params = {}
      params[:type] = type if type

      get("/rest/asset/v1/folder/#{id}.json", params)
    end

    def get_folder_by_name(name, type: nil, root: nil, work_space: nil)
      params = {
        name: name
      }

      optional = {
        root: root&.to_json,
        type: type,
        workSpace: work_space
      }

      get('/rest/asset/v1/folder/byName.json', params, optional)
    end

    def delete_folder(id)
      post("/rest/asset/v1/folder/#{id}/delete.json")
    end
  end
end
