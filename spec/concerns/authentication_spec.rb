describe MktoRest::Authentication do
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
        expect { subject }.to raise_error(MktoRest::Errors::Error, 'Bad client credentials')
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
