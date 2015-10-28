describe Mrkt::CrudLeads do
  include_context 'initialized client'

  describe '#get_activity_types' do
    let(:date) { Date.parse("2014-09-25") }
    let(:next_page_token) { "GIYDAOBNGEYS2MBWKQYDAORQGA5DAMBOGAYDAKZQGAYDALBQ" }
    let(:response_stub) do
      {
        "requestId": "1607c#14884f3e74e",
        "success": true,
        "nextPageToken": next_page_token
      }
    end
    subject { client.get_paging_token(date) }

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities/pagingtoken.json")
        .with(query: { sinceDatetime: date.strftime("%FT%T") })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(next_page_token) }
  end
end
