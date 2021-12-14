describe Mrkt::CrudProgramMembers do
  include_context 'initialized client'

  describe '#describe_program_members' do
    subject { client.describe_program_members }

    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            name: 'API Program Membership',
            description: 'Map for API program membership fields',
            dedupeFields: %w[
              leadId
              programId
            ],
            searchableFields: [
              ['leadId'],
              ['livestormregistrationurl']
            ],
            fields: [
              {
                name: 'acquiredBy',
                displayName: 'acquiredBy',
                dataType: 'boolean',
                updateable: false,
                crmManaged: false
              },
              {
                name: 'attendanceLikelihood',
                displayName: 'attendanceLikelihood',
                dataType: 'integer',
                updateable: false,
                crmManaged: false
              }
            ]
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/programs/members/describe.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#createupdate_program_members' do
    subject { client.createupdate_program_members(program_id, lead_ids, status) }

    let(:program_id) { 123 }
    let(:lead_ids) { [1, 2, 3] }
    let(:status) { 'Registered' }
    let(:request_body) do
      {
        statusName: 'Registered',
        input: [
          { leadId: 1 },
          { leadId: 2 },
          { leadId: 3 }
        ]
      }
    end
    let(:response_stub) do
      {
          requestId: 'c00c#17d7bf40f15',
          result: [
            {
                seq: 0,
                status: 'created',
                leadId: 1
            },
            {
                seq: 1,
                status: 'created',
                leadId: 2
            },
            {
                seq: 2,
                status: 'created',
                leadId: 3
            }
          ],
          success: true
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/v1/programs/#{program_id}/members/status.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_program_members' do
    subject { client.get_program_members(program_id, filter_type, filter_values) }

    let(:filter_type) { 'leadId' }
    let(:filter_values) { [1, 2] }
    let(:program_id) { 1014 }
    let(:response_stub) do
      {
        requestId: '4b6d#17d7c0530de',
        result: [
          {
              seq: 0,
              leadId: 1,
              reachedSuccess: true,
              programId: 1014,
              acquiredBy: false,
              membershipDate: '2021-12-02T16:22:12Z'
          },
          {
              seq: 1,
              leadId: 2,
              reachedSuccess: true,
              programId: 1014,
              acquiredBy: false,
              membershipDate: '2021-12-02T16:22:12Z'
          }
        ],
        success: true,
        moreResult: false
    }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/programs/#{program_id}/members.json")
        .with(query: { filterType: filter_type, filterValues: filter_values.join(',') })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
