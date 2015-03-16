def set_authentication_stub_request(hostname, client_id, client_key)
  body = {
    access_token: 'e58af350-6c40-453f-8883-35f12d2e8742:qe',
    token_type: 'bearer',
    expires_in: 86183,
    scope: 'ser@user.com'
  }

  stub_request(:get, "https://#{hostname}/identity/oauth/token?client_id=#{client_id}&client_secret=#{client_key}&grant_type=client_credentials")
    .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
    .to_return(
      status: 200,
      body: body.to_json,
      headers: {}
    )
end

def set_create_leads_stub_request(leads, hostname, token, options = nil)
  # Endpoint expects these headers
  headers = {
    'Authorization' => "Bearer #{token}",
    'Content-Type' => 'application/json',
    'Accept' => '*/*',
    'User-Agent' => 'Ruby'
  }
  url = "https://#{hostname}/rest/v1/leads.json"
  # taken from dev.marekto.com
  req_body = {
    'action' => 'createOnly',
    'input' => []
  }
  if options
    req_body['partitionName'] = options[:partition] if options[:partition]
    req_body['lookupField'] = options[:lookupField] if options[:lookupField]
  end
  leads.each do |l|
    req_body['input'] << l
  end

  # talen from dev.marketo.com
  resp_body = {
    'requestId' => 'e42b#14272d07d78',
    'success' => true,
    'result' => []
  }
  stub_request(:post, url).with(headers: headers, body: req_body.to_json)
    .to_return(status: 200, body: resp_body.to_json, headers: {})
end

def set_get_leads_stub_request(type, email, hostname, token)
  url = "https://#{hostname}/rest/v1/leads.json?access_token=#{token}&filterType=#{type}&filterValues=#{email}"

  # expected body
  body = {
    requestId: 1,
    success: true,
    result: [
      {
        id: 1,
        email: email
      }
    ]
  }

  stub_request(:get, url).with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
    .to_return(status: 200, body: body.to_json)
end

def set_update_lead_stub_request(type, value, fields, hostname, token)
  # Endpoint expect this body
  req_body = {
    action: 'updateOnly',
    lookupField: type.to_s,
    input: [{ type => value }.merge(fields)]
  }.to_json

  # Endpoint expects these headers
  headers = {
    'Authorization' => "Bearer #{token}",
    'Content-Type' => 'application/json',
    'Accept' => '*/*',
    'User-Agent' => 'Ruby'
  }

  # response expected body
  resp_body = {
    requestId: 1,
    success: true,
    result: [
      {
        type.to_s => value
      }
    ]
  }.to_json

  stub_request(:post, "https://#{hostname}/rest/v1/leads.json")
    .with(headers: headers, body: req_body)
    .to_return(status: 200, body: resp_body)
end
