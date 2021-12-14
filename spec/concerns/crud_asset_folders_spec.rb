describe Mrkt::CrudAssetFolders do
  include_context 'with an initialized client'

  let(:response_folder_result) do
    {
      name: 'Test Folder Name',
      description: 'Optional folder description',
      createdAt: '2019-03-15T23:31:00Z+0000',
      updatedAt: '2019-03-15T23:31:00Z+0000',
      url: 'https://app-devlocal1.marketo.com/#ML0A1ZN75',
      folderId: {
        id: 75,
        type: 'Folder'
      },
      folderType: 'Zone',
      parent: {
        id: 5,
        type: 'Folder'
      },
      path: '/Lead Database/Default/Test Folder Name',
      isArchive: false,
      isSystem: false,
      accessZoneId: 1,
      workspace: 'Default',
      id: 75
    }
  end

  describe '#create_folder' do
    subject { client.create_folder(name, parent, description: description) }

    let(:name) { 'Test Folder Name' }
    let(:parent) do
      { id: 5, type: 'Folder' }
    end
    let(:description) { 'Optional folder description' }
    let(:response_stub) do
      {
        requestId: 'bf7d#16983b1c7e3',
        result: [
          response_folder_result
        ],
        success: true,
        errors: [],
        warnings: []
      }
    end

    let(:json_parent) { JSON.generate(parent) }
    let(:request_body) do
      {
        name: name,
        parent: json_parent,
        description: description
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/folders.json")
        .with(body: request_body)
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_folder_by_id' do
    subject(:action) { client.get_folder_by_id(id, type: type) }

    let(:id) { 77 }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/folder/#{id}.json?type=#{type}")
        .to_return(json_stub(response_stub))
    end

    context 'when a folder with the given id exists' do
      let(:type) { 'Folder' }
      let(:response_stub) do
        {
          requestId: '12756#16983bd0ee5',
          result: [
            response_folder_result
          ],
          success: true,
          errors: [],
          warnings: []
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when a folder with the given id does not exist' do
      let(:type) { 'Folder' }
      let(:response_stub) do
        {
          requestId: '18087#16983c04cdf',
          success: true,
          errors: [],
          warnings: [
            'No assets found for the given search criteria.'
          ]
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when the given type is not acceptable' do
      let(:type) { 'Unacceptable' }
      let(:response_stub) do
        {
          requestId: '12776#16983c25b1d',
          success: false,
          warnings: [],
          errors: [
            {
              code: '1001',
              message: "Invalid value 'Unacceptable'. Required of type 'FolderVariantType'"
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::TypeMismatch)
      end
    end
  end

  describe '#get_folder_by_name' do
    subject(:action) { client.get_folder_by_name(name, type: type, root: root, work_space: work_space) }

    let(:name) { 'Test Folder Name' }
    let(:type) { 'Folder' }
    let(:root) do
      {
        id: 5,
        type: 'Folder'
      }
    end
    let(:work_space) { 'Default' }

    let(:json_root) { JSON.generate(root) }
    let(:request_query) { "name=#{name}&type=#{type}&root=#{json_root}&workSpace=#{work_space}" }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/folder/byName.json?#{request_query}")
        .to_return(json_stub(response_stub))
    end

    context 'when a folder with the given name exists' do
      let(:response_stub) do
        {
          requestId: '541#16983d2f549',
          result: [
            response_folder_result
          ],
          success: true,
          errors: [],
          warnings: []
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when a folder with the given name does not exist' do
      let(:response_stub) do
        {
          requestId: '105ad#16983d557c5',
          success: true,
          errors: [],
          warnings: [
            'No assets found for the given search criteria.'
          ]
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when the given work_space does not exist' do
      let(:response_stub) do
        {
          requestId: '17af3#16983da0349',
          success: false,
          warnings: [],
          errors: [
            {
              code: '611',
              message: 'Unable to get folder'
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::System)
      end
    end

    context 'when the given type is not acceptable' do
      let(:response_stub) do
        {
          requestId: '2225#16983db0b71',
          success: false,
          warnings: [],
          errors: [
            {
              code: '1003',
              message: 'Invalid request. Please check and try again.'
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::UnspecifiedAction)
      end
    end
  end

  describe '#delete_folder' do
    subject(:action) { client.delete_folder(id) }

    let(:id) { 75 }

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/folder/#{id}/delete.json")
        .to_return(json_stub(response_stub))
    end

    context 'when a folder with the given id exists' do
      let(:response_stub) do
        {
          requestId: '1a1a#16983eaa800',
          result: [
            {
              id: 75
            }
          ],
          success: true,
          errors: [],
          warnings: []
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when a folder with the given id does not exist' do
      let(:response_stub) do
        {
          requestId: '102ee#16983f320fb',
          success: false,
          warnings: [],
          errors: [
            {
              code: '702',
              message: '75 Folder not found'
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::RecordNotFound)
      end
    end
  end
end
