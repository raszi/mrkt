describe Mrkt::CrudLists do
  include_context 'initialized client'

  describe '#get_leads_by_list' do
    subject { client.get_leads_by_list(list_id) }

    let(:list_id) { '1001' }
    let(:response_stub) do
      {
        requestId: 'ab12#12d6ab65024',
        result: [
          {
            id: 1,
            firstName: nil,
            lastName: nil,
            email: 'sample@example.com',
            updatedAt: '2015-05-19 13:50:57',
            createdAt: '2015-05-19 13:50:57'
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/list/#{list_id}/leads.json")
        .with(query: {})
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#add_leads_to_list' do
    subject { client.add_leads_to_list(list_id, lead_ids) }

    let(:list_id) { '1001' }
    let(:lead_ids) { ['1'] }
    let(:request_body) do
      {
        input: [
          { id: '1' }
        ]
      }
    end
    let(:response_stub) do
      {
        requestId: '16d3f#14d6da7449f',
        result: [
          {
            id: 1,
            status: 'added'
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/v1/lists/#{list_id}/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#remove_leads_from_list' do
    subject { client.remove_leads_from_list(list_id, lead_ids) }

    let(:list_id) { '1001' }
    let(:lead_ids) { ['1'] }
    let(:request_body) do
      {
        input: [
          { id: '1' }
        ]
      }
    end
    let(:response_stub) do
      {
        requestId: '10de4#1697e81c821',
        result: [
          {
            id: 1,
            status: 'removed'
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:delete, "https://#{host}/rest/v1/lists/#{list_id}/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
