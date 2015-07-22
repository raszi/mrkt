describe Mrkt::CrudCampaigns do
  include_context 'initialized client'

  describe '#request_campaign' do
    let(:id) { 42 }
    let(:lead_ids) { [1234, 5678] }
    let(:tokens) do
      [{
         name:  '{{my.message}}',
         value: 'Updated message'
       }, {
         name:  '{{my.other token}}',
         value: 'Value for other token'
       }]
    end
    subject { client.request_campaign(id, lead_ids, tokens) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/campaigns/#{id}/trigger.json")
        .with(body: { input: { leads: lead_ids.map { |id| { id: id } }, tokens: tokens } })
        .to_return(json_stub(response_stub))
    end

    context 'with an invalid campaign id' do
      let(:response_stub) do
        {
          requestId: 'a9b#14eb6771358',
          success:   false,
          errors:    [{
                        code:    '1013',
                        message: 'Campaign not found'
                      }]
        }
      end

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::ObjectNotFound)
      end
    end

    context 'with valid campaign id' do
      context 'with invalid lead id' do
        let(:response_stub) do
          {
            requestId: '7cdc#14eb6ae8a86',
            success:   false,
            errors:    [{
                          code:    '1004',
                          message: 'Lead [1234] not found'
                        }]
          }
        end

        it 'should raise an Error' do
          expect { subject }.to raise_error(Mrkt::Errors::LeadNotFound)
        end
      end

      context 'for valid lead ids' do
        let(:response_stub) do
          {
            requestId: 'e42b#14272d07d78',
            success:   true
          }
        end

        it { is_expected.to eq(response_stub) }
      end
    end
  end
end
