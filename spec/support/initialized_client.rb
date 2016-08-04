require 'securerandom'
require 'json'

shared_context 'initialized client' do
  let(:host) { '0-KBZ-0.mktorest.com' }
  let(:client_id) { SecureRandom.uuid }
  let(:client_secret) { SecureRandom.hex }
  let(:authentication_stub) do
    { access_token: SecureRandom.uuid, token_type: 'bearer', expires_in: 2241, scope: 'RestClient' }
  end

  subject(:client) { Mrkt::Client.new(host: host, client_id: client_id, client_secret: client_secret) }

  before do
    @authentication_request_stub = stub_request(:get, "https://#{host}/identity/oauth/token")
      .with(query: { client_id: client_id, client_secret: client_secret, grant_type: 'client_credentials' })
      .to_return(json_stub(authentication_stub))
  end
end
