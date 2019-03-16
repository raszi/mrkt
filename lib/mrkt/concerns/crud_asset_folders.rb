module Mrkt
  module CrudAssetFolders
    def create_folder(name, parent, description: nil)
      post('/rest/asset/v1/folders.json') do |req|
        params = {
          name: name,
          parent: JSON.generate(parent)
        }
        params[:description] = description if description

        req.body = params
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
      params[:type] = type if type
      params[:root] = JSON.generate(root) if root
      params[:workSpace] = work_space if work_space

      get("/rest/asset/v1/folder/byName.json", params)
    end

    def delete_folder(id)
      post("/rest/asset/v1/folder/#{id}/delete.json")
    end
  end
end
