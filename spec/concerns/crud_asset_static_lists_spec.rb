describe Mrkt::CrudAssetStaticLists do
  include_context 'initialized client'

  let(:response_static_list_result) do
    {
      id: 1001,
      name: 'Test Static List Name',
      description: 'Provided description',
      createdAt: '2019-03-15T21:41:46Z+0000',
      updatedAt: '2019-03-15T21:41:46Z+0000',
      folder: {
        id: 14,
        type: 'Folder'
      },
      computedUrl: 'https://app-devlocal1.marketo.com/#ST1001A1'
    }
  end

  describe '#create_static_list' do
    subject { client.create_static_list(name, folder, description: description) }

    let(:name) { 'Test Static List Name' }
    let(:folder) do
      { id: 14, type: 'Folder' }
    end
    let(:description) { 'Provided description' }
    let(:response_stub) do
      {
        requestId: 'eba#16982091b99',
        result: [
          response_static_list_result
        ],
        success: true,
        errors: [],
        warnings: []
      }
    end

    let(:json_folder) { JSON.generate(folder) }
    let(:request_body) do
      {
        name: name,
        folder: json_folder,
        description: description
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/staticLists.json")
        .with(body: request_body)
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_static_list_by_id' do
    subject { client.get_static_list_by_id(id) }

    let(:id) { response_static_list_result[:id] }
    let(:response_stub) do
      {
        requestId: '378a#16983419fff',
        result: [
          response_static_list_result
        ],
        success: true,
        errors: [],
        warnings: []
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/staticList/#{id}.json")
        .to_return(json_stub(response_stub))
    end

    context 'when a static list with the given id exists' do
      let(:response_stub) do
        {
          requestId: '378a#16983419fff',
          result: [
            response_static_list_result
          ],
          success: true,
          errors: [],
          warnings: []
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when a static list with the given id does not exist' do
      let(:response_stub) do
        {
          requestId: 'a8d#1698369857b',
          success: false,
          warnings: [],
          errors: [
            {
              code: '702',
              message: 'Static List not found or it has been deleted'
            }
          ]
        }
      end

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::RecordNotFound)
      end
    end
  end

  describe '#get_static_list_by_name' do
    subject { client.get_static_list_by_name(name) }

    let(:name) { 'Test Static List Name' }
    let(:request_query) { "name=#{name}" }

    before do
      stub_request(:get, "https://#{host}/rest/asset/v1/staticList/byName.json?#{request_query}")
        .to_return(json_stub(response_stub))
    end

    context 'when a static list with the given name exists' do
      let(:response_stub) do
        {
          requestId: '13a74#169834522b9',
          result: [
            response_static_list_result
          ],
          success: true,
          errors: [],
          warnings: []
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when a static list with the given name does not exist' do
      let(:response_stub) do
        {
          requestId: '4ec2#1698384ae02',
          success: true,
          errors: [],
          warnings: [
            'No assets found for the given search criteria.'
          ]
        }
      end

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#delete_static_list' do
    subject { client.delete_static_list(id) }

    let(:id) { 1001 }
    let(:response_stub) do
      {
        requestId: '94c3#169833275df',
        result: [
          {
            id: 1001
          }
        ],
        success: true,
        errors: [],
        warnings: []
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/asset/v1/staticList/#{id}/delete.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
