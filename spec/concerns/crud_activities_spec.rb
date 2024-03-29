describe Mrkt::CrudActivities do
  include_context 'with an initialized client'

  describe '#get_activity_types' do
    subject { client.get_activity_types }

    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            id: 1,
            name: 'Visit Webpage',
            description: 'User visits a web page',
            primareAttributes: {
              name: 'Webpage ID',
              dataType: 'integer'
            },
            attributes: [
              {
                name: 'Query Parameters',
                dataType: 'string'
              },
              {
                name: 'Webpage URL',
                dataType: 'string'
              }
            ]
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities/types.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_paging_token' do
    subject { client.get_paging_token(since_datetime) }

    let(:since_datetime) { Time.utc(2017, 1, 1, 4, 30) }
    let(:response_stub) do
      {
        requestId: '12eb3#1599b371c62',
        success: true,
        nextPageToken: '4GAX7YNCIJKO2VAED5LH5PQIYPUM7WCVKTQWEDMP2L24AXZT54LA===='
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities/pagingtoken.json")
        .with(query: { sinceDatetime: '2017-01-01T04:30:00Z' })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_activities' do
    subject { client.get_activities(token) }

    let(:activity_type_ids) { [1, 2] }
    let(:lead_ids) { [100, 102] }
    let(:token) { '4GAX7YNCIJKO2VAED5LH5PQIYPUM7WCVKTQWEDMP2L24AXZT54LA====' }
    let(:response_stub) do
      {
        data: {
          requestId: '417b#1599b3bca62',
          result: [
            {
              id: 500,
              leadId: 100,
              activityDate: '2017-01-01T07:53:29Z',
              activityTypeId: 1,
              primaryAttributeValueId: 29,
              primaryAttributeValue: 'test',
              attributes: [
                {
                  name: 'Query Parameters',
                  value: ''
                },
                {
                  name: 'Webpage URL',
                  value: '/test.html'
                }
              ]
            },
            {
              id: 456,
              leadId: 101,
              activityDate: '2017-01-01T08:13:36Z',
              activityTypeId: 12,
              primaryAttributeValueId: 101,
              attributes: [
                {
                  name: 'Form Name',
                  value: 'Sign Up'
                }
              ]
            }
          ]
        },
        success: true,
        nextPageToken: 'WQV2VQVPPCKHC6AQYVK7JDSA3I5PBAJNUNY3CR563KMVM7F43OIQ====',
        moreResult: false
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities.json")
        .with(query: { nextPageToken: token })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }

    context 'when specifying activity type ids' do
      subject { client.get_activities(token, activity_type_ids: activity_type_ids) }

      let(:response_stub) do
        {
          data: {
            requestId: '417b#1599b3bca62',
            result: [
              {
                id: 500,
                leadId: 100,
                activityDate: '2017-01-01T07:53:29Z',
                activityTypeId: 1,
                primaryAttributeValueId: 29,
                primaryAttributeValue: 'test',
                attributes: [
                  {
                    name: 'Query Parameters',
                    value: ''
                  },
                  {
                    name: 'Webpage URL',
                    value: '/test.html'
                  }
                ]
              }
            ]
          },
          success: true,
          nextPageToken: 'WQV2VQVPPCKHC6AQYVK7JDSA3I5PBAJNUNY3CR563KMVM7F43OIQ====',
          moreResult: false
        }
      end

      before do
        stub_request(:get, "https://#{host}/rest/v1/activities.json")
          .with(query: {
            nextPageToken: token,
            activityTypeIds: activity_type_ids.join(',')
          })
          .to_return(json_stub(response_stub))
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when specifying lead ids' do
      subject { client.get_activities(token, lead_ids: lead_ids) }

      let(:response_stub) do
        {
          data: {
            requestId: '417b#1599b3bca62',
            result: [
              {
                id: 500,
                leadId: 100,
                activityDate: '2017-01-01T07:53:29Z',
                activityTypeId: 1,
                primaryAttributeValueId: 29,
                primaryAttributeValue: 'test',
                attributes: [
                  {
                    name: 'Query Parameters',
                    value: ''
                  },
                  {
                    name: 'Webpage URL',
                    value: '/test.html'
                  }
                ]
              }
            ]
          },
          success: true,
          nextPageToken: 'WQV2VQVPPCKHC6AQYVK7JDSA3I5PBAJNUNY3CR563KMVM7F43OIQ====',
          moreResult: false
        }
      end

      before do
        stub_request(:get, "https://#{host}/rest/v1/activities.json")
          .with(query: { nextPageToken: token, leadIds: lead_ids.join(',') })
          .to_return(json_stub(response_stub))
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when specifying arrays values as empty strings' do
      subject do
        client.get_activities(token, activity_type_ids: activity_type_ids, lead_ids: lead_ids)
      end

      let(:activity_type_ids) { '' }
      let(:lead_ids) { '' }

      before do
        stub_request(:get, "https://#{host}/rest/v1/activities.json")
          .with(query: { nextPageToken: token })
          .to_return(json_stub(response_stub))
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when specifying all options' do
      subject do
        client.get_activities(token, activity_type_ids: activity_type_ids, lead_ids: lead_ids)
      end

      before do
        stub_request(:get, "https://#{host}/rest/v1/activities.json")
          .with(query: {
            nextPageToken: token,
            activityTypeIds: activity_type_ids.join(','),
            leadIds: lead_ids.join(',')
          })
          .to_return(json_stub(response_stub))
      end

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#get_deleted_leads' do
    subject { client.get_deleted_leads(token) }

    let(:token) { '4GAX7YNCIJKO2VAED5LH5PQIYPUM7WCVKTQWEDMP2L24AXZT54LA====' }
    let(:response_stub) do
      {
        requestId: '8105#1650074c30c',
        result:  [
          {
            id: 12_751,
            marketoGUID: '12751',
            leadId: 277,
            activityDate: '2018-08-03T14:58:53Z',
            activityTypeId: 37,
            campaignId: 5227,
            primaryAttributeValueId: 277,
            primaryAttributeValue: 'Delete Me',
            attributes:  [
              {
                name: 'Campaign',
                value: 'Run Action Delete Lead 2018-08-03 04:58:50 pm'
              }
            ]
          }
        ],
        success: true,
        nextPageToken: 'XQH6SLHODNIM7CY6MKJ6GAOR3JYOQXIN3THAHKYZXSOYN4HOPR2Q====',
        moreResult: false
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/activities/deletedleads.json")
        .with(query: { nextPageToken: token })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
