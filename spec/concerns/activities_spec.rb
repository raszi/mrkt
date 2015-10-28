describe Mrkt::Activities do
  include_context 'initialized client'

  describe '#get_activity_types' do
    let(:response_stub) do
      {
        "requestId":"6e78#148ad3b76f1",
        "success":true,
        "result":[
          {
            "id":1,
            "name":"Visit Webpage",
            "description":"User visits web page",
            "primaryAttribute":{
              "name":"Webpage ID",
              "dataType":"integer"
            },
            "attributes":[
              { "name":"Client IP Address", "dataType":"string" },
              { "name":"Query Parameters", "dataType":"string" },
              { "name":"Referrer URL", "dataType":"string" },
              { "name":"Search Engine", "dataType":"string" },
              { "name":"Search Query", "dataType":"string" },
              { "name":"User Agent", "dataType":"string" },
              { "name":"Webpage URL", "dataType":"string" }
            ]
          },
          {
            "id":2,
            "name":"Fill Out Form",
            "description":"User fills out and submits form on web page",
            "primaryAttribute":{
              "name":"Webform ID",
              "dataType":"integer"
            },
            "attributes":[
              { "name":"Client IP Address", "dataType":"string" },
              { "name":"Form Fields", "dataType":"text" },
              { "name":"Query Parameters", "dataType":"string" },
              { "name":"Referrer URL", "dataType":"string" },
              { "name":"User Agent", "dataType":"string" },
              { "name":"Webpage ID", "dataType":"integer" }
            ]
          }
        ]
      }
    end
    subject { client.get_activity_types }

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities/types.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_activities' do
    let(:date) { Date.new(2013, 9, 25) }
    let(:first_page_token) { "GIYDAOBNGEYS2MBWKQYDAORQGA5DAMBOGAYDAKZQGAYDALBQ" }
    let(:activity_type_ids) { [1, 12] }
    let(:first_response_stub) do
      {
        "requestId":"a9ae#148add1e53d",
        "success":true,
        "nextPageToken":"EYS2MBWKQYDAORQGA5D",
        "moreResult":true,
        "result":[
          {
            "id":2,
            "leadId":6,
            "activityDate":"2013-09-25T00:39:45+0000",
            "activityTypeId":12,
            "primaryAttributeValueId":6,
            "primaryAttributeValue":"Owyliphys Iledil",
            "attributes":[ { "name":"Source Type", "value":"Web page visit" } ]
          },
          {
            "id":3,
            "leadId":9,
            "activityDate":"2013-09-25T06:56:35+0000",
            "activityTypeId":1,
            "primaryAttributeValueId":4,
            "primaryAttributeValue":"anti-phishing",
            "attributes":[ { "name":"Query Parameters", "value":nil } ]
          }
        ]
      }
    end

    subject { client.get_activities(first_page_token, date, activity_type_ids) }

    before do
      activity_type_ids_params = activity_type_ids.map { |id| "activityTypeIds=#{id}" }.join("&")
      stub_request(:get, "https://#{host}/rest/v1/activities.json?nextPageToken=#{first_page_token}&#{activity_type_ids_params}")
        .to_return(json_stub(first_response_stub))
    end

    it { is_expected.to eq(first_response_stub) }
  end
end
