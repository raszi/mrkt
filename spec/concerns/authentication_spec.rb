describe Mrkt::Authentication do
  include_context 'initialized client'

  describe '#authenticate' do
    subject(:action) { client.authenticate }

    context 'with on a successful response' do
      it { is_expected.to be_success }
    end

    context 'when the token is invalid' do
      let(:authentication_stub) do
        {
          error: 'invalid_client',
          error_description: 'Bad client credentials'
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::Error, 'Bad client credentials')
      end
    end
  end

  describe '#authenticate!' do
    it 'authenticates and then be authenticated?' do
      expect(client.authenticated?).not_to be true

      client.authenticate!
      expect(client.authenticated?).to be true
    end

    context 'with optional partner_id client option' do
      subject(:client) { Mrkt::Client.new(client_options) }

      before do
        remove_request_stub(@authentication_request_stub)

        stub_request(:get, "https://#{host}/identity/oauth/token")
          .with(query: query)
          .to_return(json_stub(authentication_stub))
      end

      let(:partner_id) { SecureRandom.uuid }

      let(:client_options) do
        {
          host: host,
          client_id: client_id,
          client_secret: client_secret,
          partner_id: partner_id
        }
      end

      let(:query) do
        {
          client_id: client_id,
          client_secret: client_secret,
          partner_id: partner_id,
          grant_type: 'client_credentials'
        }
      end

      it 'authenticates and then be authenticated?' do
        expect(client.authenticated?).not_to be true
        client.authenticate!
        expect(client.authenticated?).to be true
      end
    end

    context 'when the token has expired and @retry_authentication = true' do
      subject(:client) { Mrkt::Client.new(client_options) }

      before do
        remove_request_stub(@authentication_request_stub)

        stub_request(:get, "https://#{host}/identity/oauth/token")
          .with(query: { client_id: client_id, client_secret: client_secret, grant_type: 'client_credentials' })
          .to_return(json_stub(expired_authentication_stub)).times(3).then
          .to_return(json_stub(valid_authentication_stub))
      end

      let(:retry_count) { 3 }

      let(:expired_authentication_stub) do
        { access_token: SecureRandom.uuid, token_type: 'bearer', expires_in: 0, scope: 'RestClient' }
      end

      let(:valid_authentication_stub) do
        { access_token: SecureRandom.uuid, token_type: 'bearer', expires_in: 1234, scope: 'RestClient' }
      end

      let(:client_options) do
        {
          host: host,
          client_id: client_id,
          client_secret: client_secret,
          retry_authentication: true,
          retry_authentication_count: retry_count
        }
      end

      it 'retries until getting valid token and then be authenticated?' do
        expect(client.authenticated?).not_to be true
        client.authenticate!
        expect(client.authenticated?).to be true
      end

      context 'when retry_authentication_count is low' do
        let(:retry_count) { 2 }

        it 'stops retrying after @retry_authentication_count tries and then raise an error' do
          expect(client.authenticated?).not_to be true

          expect { client.authenticate! }.to raise_error(Mrkt::Errors::Error, 'Client not authenticated')
        end
      end
    end
  end

  describe '#authenticated?' do
    subject { client.authenticated? }

    context 'when authentication has not been done' do
      it { is_expected.to be_falsey }
    end

    context 'when authentication has been done' do
      before { client.authenticate }

      it { is_expected.to be_truthy }
    end
  end
end
