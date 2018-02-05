module Mrkt
  module CrudEmails
    def get_email_by_id(id)
      get("/rest/asset/v1/email/#{id}.json")
    end

    def get_email_by_name(name)
      params = {
        name: name
      }

      get("/rest/asset/v1/email/byName.json", params)
    end

    def get_email_content(id)

      get("/rest/asset/v1/email/#{id}/content.json")
    end

  end
end
