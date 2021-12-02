describe Mrkt::CrudProgramMembers do
  include_context 'initialized client'

  describe '#describe_program_members' do
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
    subject { client.describe_program_members }

    before do
      stub_request(:get, "https://#{host}/rest/v1/programs/members/describe.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#createupdate_program_members' do
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
    subject { client.createupdate_program_members(program_id, lead_ids, status) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/programs/#{program_id}/members/status.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
