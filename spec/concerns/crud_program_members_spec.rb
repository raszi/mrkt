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
end
