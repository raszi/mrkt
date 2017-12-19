require 'tempfile'

describe Mrkt::ImportCustomObjects do
  include_context 'initialized client'
  let(:custom_object) { 'car_c' }

  describe '#import_custom_object' do
    let(:file) { StringIO.new }
    let(:response_stub) do
      {
        requestId: 'c015#15a68a23418',
        success: true,
        result: [
          {
            batchId: 1,
            status: 'Importing',
            objectApiName: custom_object
          }
        ]
      }
    end
    subject { client.import_custom_object(file, custom_object) }

    before do
      stub_request(:post, "https://#{host}/bulk/v1/customobjects/#{custom_object}/import.json")
        .with(headers: { content_type: %r{multipart/form-data; boundary=\S+} })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_custom_object_status' do
    let(:id) { 1 }
    let(:response_stub) do
      {
        requestId: '2a5#15a68dd9be1',
        result: [
          {
            batchId: id,
            operation: 'import',
            status: 'Complete',
            objectApiName: 'car_c',
            numOfObjectsProcessed: 3,
            numOfRowsFailed: 0,
            numOfRowsWithWarning: 0,
            importTime: '2 second(s)',
            message: 'Import succeeded, 3 records imported (3 members)'
          }
        ],
        success: true
      }
    end
    subject { client.import_custom_object_status(1, custom_object) }

    before do
      stub_request(:get, "https://#{host}/bulk/v1/customobjects/#{custom_object}/import/#{id}/status.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_custom_object_failures' do
    let(:id) { 1 }
    let(:response_stub) { '' }
    subject { client.import_custom_object_failures(1, custom_object) }

    before do
      stub_request(:get, "https://#{host}/bulk/v1/customobjects/#{custom_object}/import/#{id}/failures.json")
        .to_return(headers: { content_length: 0 })
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_custom_object_warnings' do
    let(:id) { 1 }
    let(:response_stub) { '' }
    subject { client.import_custom_object_warnings(1, custom_object) }

    before do
      stub_request(:get, "https://#{host}/bulk/v1/customobjects/#{custom_object}/import/#{id}/warnings.json")
        .to_return(headers: { content_length: 0 })
    end

    it { is_expected.to eq(response_stub) }
  end
end
