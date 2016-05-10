describe Mrkt::CrudPrograms do
  include_context 'initialized client'

  describe '#browse_programs' do
    let(:response_stub) do
      {
        success: true,
        warnings: [],
        errors: [],
        requestId: '7a39#1511bf8a41c',
        result: [
          {
            id: 1035,
            name: 'clone it',
            description: '',
            createdAt: '2015-11-18T15:25:35Z+0000',
            updatedAt: '2015-11-18T15:25:46Z+0000',
            url: 'https://app-devlocal1.marketo.com/#NP1035A1',
            type: 'Engagement',
            channel: 'Nurture',
            folder: {
              type: 'Folder',
              value: 28,
              folderName: 'Nurturing'
            },
            status: 'on',
            workspace: 'Default'
          }
        ]
      }
    end

    subject { client.browse_programs }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/programs.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_program_by_id' do
    let(:response_stub) do
      {
        success: true,
        warnings: [],
        errors: [],
        requestId: '948f#14db037ec71',
        result: [
          {
            id: 1107,
            name: 'AAA2QueryProgramName',
            description: 'AssetAPI: getProgram tests',
            createdAt: '2015-05-21T22:45:13Z+0000',
            updatedAt: '2015-05-21T22:45:13Z+0000',
            url: 'https://app-devlocal1.marketo.com/#PG1107A1',
            type: 'Default',
            channel: 'Online Advertising',
            folder: {
              type: 'Folder',
              value: 1910,
              folderName: 'ProgramQueryTestFolder'
            },
            status: '',
            workspace: 'Default',
            tags: [
              {
                tagType: 'AAA1 Required Tag Type',
                tagValue: 'AAA1 RT1'
              }
            ],
            costs: nil
          }
        ]
      }
    end

    subject { client.get_program_by_id(1107) }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/program/1107.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
