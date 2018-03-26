describe Mrkt::CrudCampaigns do
  include_context 'initialized client'

  describe '#get_email_by_id' do
    let(:id) { 42 }

    subject { client.get_email_by_id(id) }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/email/#{id}.json")
        .to_return(json_stub(response_stub))
    end

    context 'with invalid email id' do
      let(:response_stub) do
        {
          requestId: '7cdc#14eb6ae8a86',
          success:   true,
          warnings:  ["No assets found for the given search criteria."]
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'for valid email id' do
      let(:response_stub) do
        {
          requestId: 'e42b#14272d07d78',
          success:   true
        }
      end

      it { is_expected.to eq(response_stub) }
    end
  end



  describe '#approve_email_draft' do
    let(:id) { 42 }

    subject { client.approve_email_draft(id) }

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/email/#{id}/approveDraft.json")
        .to_return(json_stub(response_stub))
    end

    context 'with an invalid email id' do
      let(:response_stub) do
        {
          requestId: 'a2b#9a4567d34f',
          success:   false,
          errors:    [{
                        code:    '702',
                        message: 'Email not found'
                      }]
        }
      end

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::NoDataFound)
      end
    end

    context 'with valid email id' do
      let(:response_stub) do
        {
          requestId: 'e42b#14272d07d78',
          success:   true,
          :result=>[{:id=>42}]
        }
      end

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#update_email' do
    let(:id) { 42 }
    let(:email_subject) { "Test" }

    subject { client.update_email(id, email_subject) }

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/email/#{id}/content.json?subject={'type':'Text','value':'#{email_subject}'}")
        .to_return(json_stub(response_stub))
    end

    context 'with an invalid email id' do
      let(:response_stub) do
        {
          requestId: 'a2b#9a4567d34f',
          success:   false,
          errors:    [{
                        code:    '702',
                        message: 'Email not found'
                      }]
        }
      end

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::NoDataFound)
      end
    end

    context 'with valid email id' do
      let(:response_stub) do
        {
          requestId: 'e42b#14272d07d78',
          success:   true,
          :result=>[{:id=>42}]
        }
      end

      it { is_expected.to eq(response_stub) }
    end
  end

end
