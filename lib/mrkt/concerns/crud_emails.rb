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

    def approve_email_draft(id)
      post("/rest/asset/v1/email/#{id}/approveDraft.json")
    end

    def update_email(id)
      post("/rest/asset/v1/email/#{id}/content.json") do
        { subject: {type: "string", value: "Announcement Alert"}}
      end
    end

    def update_email_content(id, html_id, content, text_value = nil)
      post("/rest/asset/v1/email/#{id}/content/#{html_id}.json") do |req|
        req.headers[:content_type] = 'multipart/form-data;charset=UTF-8'
        req.body = {type: "Text", value: content}
      end
    end

    def update_email_full_content(id, content)
      payload = {}
      payload[:content] = Faraday::UploadIO.new(content.path, 'text/html')
      # payload = {content: content}
      post("/rest/asset/v1/email/#{id}/fullContent.json", payload) do |req|
        req.headers[:content_type] = 'multipart/form-data;charset=UTF-8'
      end
    end

  end
end
