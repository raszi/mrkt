module Mrkt
  module CrudAssetStaticLists
    def create_static_list(name, folder, description: nil)
      post('/rest/asset/v1/staticLists.json') do |req|
        params = {
          name: name,
          folder: JSON.generate(folder)
        }
        params[:description] = description if description

        req.body = params
      end
    end

    def get_static_list_by_id(id)
      get("/rest/asset/v1/staticList/#{id}.json")
    end

    def get_static_list_by_name(name)
      get('/rest/asset/v1/staticList/byName.json', name: name)
    end

    def delete_static_list(id)
      post("/rest/asset/v1/staticList/#{id}/delete.json")
    end
  end
end
