describe Mrkt::CrudCustomObjects do
  include_context 'initialized client'

  describe '#get_list_of_custom_activity_types' do
    let(:response_stub) do
      {
        requestId: '14ff3#1579a716c12',
        result: [
          {
            id: 1,
            name: 'Visit Webpage',
            description: 'User visits a web page',
            primaryAttribute: {
              name: 'Webpage ID',
              dataType: 'integer'
            },
            attributes: [
              {
                name: 'Client IP Address',
                dataType: 'string'
              },
              {
                name: 'Query Parameters',
                dataType: 'string'
              }
            ]
          },
          {
            id: 1,
            name: 'Visit Webpage',
            description: 'User visits a web page',
            primaryAttribute: {
              name: 'Webpage ID',
              dataType: 'integer'
            },
            attributes: [
              {
                name: 'Client IP Address',
                dataType: 'string'
              },
              {
                name: 'Query Parameters',
                dataType: 'string'
              }
            ]
          }
        ],
        success: true
      }
    end

    context 'all activities' do
      before do
        stub_request(:get, "https://#{host}/rest/v1/activities/types.json")
          .to_return(json_stub(response_stub))
      end

      subject { client.get_list_of_custom_activity_types }

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#create_custom_activity' do
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            activityDate: 'string',
            activityTypeId: 0,
            apiName: 'string',
            attributes: [
              {
                apiName: 'string',
                name: 'string',
                value: {}
              }
            ],
            id: 0,
            leadId: 0,
            primaryAttributeValue: 'string',
            status: 'created'
          }
        ],
        success: true
      }
    end

    let(:lead_id) do
      1
    end

    let(:activity_type_id) do
      100_000
    end

    let(:primary_attribute_value) do
      'Friday'
    end

    let(:date) do
      Time.now
    end

    context 'with no additional attributes' do
      let(:request_body) do
        {
          input: [{
            leadId: lead_id,
            activityDate: date.utc.iso8601,
            activityTypeId: activity_type_id,
            primaryAttributeValue: primary_attribute_value,
            attributes: []
          }]
        }
      end

      before do
        stub_request(:post, "https://#{host}/rest/v1/activities/external.json")
          .with(json_stub(request_body))
          .to_return(json_stub(response_stub))
      end

      subject { client.create_custom_activity(lead_id, activity_type_id, primary_attribute_value, date: date) }

      it { is_expected.to eq(response_stub) }
    end

    context 'with additional attributes' do
      let(:request_body) do
        {
          input: [{
            leadId: lead_id,
            activityDate: date.utc.iso8601,
            activityTypeId: activity_type_id,
            primaryAttributeValue: primary_attribute_value,
            attributes: [
              {
                name: 'percent',
                value: '0.20'
              },
              {
                name: 'resourceId',
                value: '_Hy8Sfk9938005SSF'
              }
            ]
          }]
        }
      end

      before do
        stub_request(:post, "https://#{host}/rest/v1/activities/external.json")
          .with(json_stub(request_body))
          .to_return(json_stub(response_stub))
      end

      let(:attributes) do
        {
          percent: '0.20',
          resourceId: '_Hy8Sfk9938005SSF'
        }
      end

      subject do
        client.create_custom_activity(lead_id, activity_type_id, primary_attribute_value, attributes: attributes, date: date)
      end

      it { is_expected.to eq(response_stub) }
    end
  end
end
