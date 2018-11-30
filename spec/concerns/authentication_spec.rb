describe Mrkt::Authentication do
  include_context 'initialized client'

  describe '#authenticate' do
    subject { client.authenticate }

    context 'on a successful response' do
      it { is_expected.to be_success }
    end

    context 'when the token is invalid' do
      let(:authentication_stub) do
        {
          error: 'invalid_client',
          error_description: 'Bad client credentials'
        }
      end

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::Error, 'Bad client credentials')
      end
    end
  end

  describe '#authenticate!' do
    it 'should authenticate and then be authenticated?' do
      expect(client.authenticated?).to_not be true
      client.authenticate!
      expect(client.authenticated?).to be true
    end

    context 'when the token has expired and @retry_authentication = true' do
      before { remove_request_stub(@authentication_request_stub) }

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

      subject(:client) { Mrkt::Client.new(client_options) }

      before do
        stub_request(:get, "https://#{host}/identity/oauth/token")
          .with(query: { client_id: client_id, client_secret: client_secret, grant_type: 'client_credentials' })
          .to_return(json_stub(expired_authentication_stub)).times(3).then
          .to_return(json_stub(valid_authentication_stub))
      end

      it 'should retry until getting valid token and then be authenticated?' do
        expect(client.authenticated?).to_not be true
        client.authenticate!
        expect(client.authenticated?).to be true
      end

      context 'when retry_authentication_count is low' do
        let(:retry_count) { 2 }

        it 'should stop retrying after @retry_authentication_count tries and then raise an error' do
          expect(client.authenticated?).to_not be true

          expect { client.authenticate! }.to raise_error(Mrkt::Errors::Error, 'Client not authenticated')
        end
      end
    end
  end

  describe '#authenticated?' do
    subject { client.authenticated? }

    context 'before authentication' do
      it { is_expected.to be_falsey }
    end

    context 'after authentication' do
      before { client.authenticate }

      it { is_expected.to be_truthy }
    end
  end
end
