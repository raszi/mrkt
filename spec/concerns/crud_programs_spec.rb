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
end
