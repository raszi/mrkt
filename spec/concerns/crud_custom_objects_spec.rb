describe Mrkt::CrudCustomObjects do
  include_context 'initialized client'

  describe '#get_list_of_custom_objects' do
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            name: 'device_c',
            displayName: 'Device',
            description: 'this is a device object',
            createdAt: '2016-01-23T00:51:18Z',
            updatedAt: '2016-01-23T00:51:18Z',
            idField: 'marketoGUID',
            dedupeFields: ['serialNumber'],
            searchableFields: [['serialNumber'], ['marketoGUID']],
            relationships: [
              {
                field: 'email',
                type: 'child',
                relatedTo: { name: 'Lead', field: 'email' }
              }
            ]
          }, {
            name: 'manufacturer_c',
            displayName: 'Manufacturer',
            createdAt: '2016-01-23T00:55:18Z',
            updatedAt: '2016-01-23T00:55:18Z',
            idField: 'marketoGUID',
            dedupeFields: ['name'],
            searchableFields: [['name'], ['marketoGUID']],
            relationships: [
              {
                field: 'email',
                type: 'child',
                relatedTo: { name: 'Lead', field: 'email' }
              }
            ]
          }
        ],
        success: true
      }
    end

    context 'with no object names' do
      before do
        stub_request(:get, "https://#{host}/rest/v1/customobjects.json")
          .to_return(json_stub(response_stub))
      end

      subject { client.get_list_of_custom_objects }

      it { is_expected.to eq(response_stub) }
    end

    context 'with object names' do
      let(:object_names) { %w[device_c manufacturer_c] }

      before do
        stub_request(:get, "https://#{host}/rest/v1/customobjects.json")
          .with(query: { names: object_names.join(',') })
          .to_return(json_stub(response_stub))
      end

      subject { client.get_list_of_custom_objects(object_names) }

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#describe_custom_object' do
    let(:response_stub) do
      {
        requestId: 'eeef#152858b17d2',
        result: [
          {
            name: 'device_c',
            displayName: 'Device',
            description: 'this is a device object',
            createdAt: '2016-01-23T00:51:18Z',
            updatedAt: '2016-01-23T00:51:18Z',
            idField: 'marketoGUID',
            dedupeFields: ['serialNumber'],
            searchableFields: [['serialNumber'], ['marketoGUID']],
            relationships: [
              {
                field: 'serialNumber',
                type: 'child',
                relatedTo: {
                  name: 'Lead',
                  field: 'serialNumber'
                }
              }
            ],
            fields: [
              {
                name: 'createdAt',
                displayName: 'Created At',
                dataType: 'datetime',
                updateable: false
              }, {
                name: 'marketoGUID',
                displayName: 'Marketo GUID',
                dataType: 'string',
                length: 36,
                updateable: false
              }, {
                name: 'updatedAt',
                displayName: 'Updated At',
                dataType: 'datetime',
                updateable: false
              }, {
                name: 'serialNumber',
                displayName: 'serial number',
                dataType: 'string',
                length: 255,
                updateable: true
              }
            ]
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/customobjects/#{object_name}/describe.json")
        .to_return(json_stub(response_stub))
    end

    subject { client.describe_custom_object(object_name) }

    context 'when the object name is valid' do
      let(:object_name) { :device_c }

      it { is_expected.to eq(response_stub) }
    end

    context 'when the object name is invalid' do
      let(:object_name) { nil }

      it 'should raise an Error' do
        expect { subject }.to raise_error(Mrkt::Errors::Unknown)
      end
    end
  end

  describe '#createupdate_custom_objects' do
    let(:object_name) { 'device' }

    let(:devices) do
      [{
        serialNumber: 'serial_number_1',
        description: 'device'
      }]
    end

    let(:request_body) do
      {
        input: [{
          serialNumber: 'serial_number_1',
          description: 'device'
        }],
        action: 'createOrUpdate',
        dedupeBy: 'dedupeFields'
      }
    end

    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        success: true,
        result: [{
          id: 1,
          status: 'created'
        }]
      }
    end

    subject { client.createupdate_custom_objects(object_name, devices) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/customobjects/#{object_name}.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#delete_custom_objects' do
    let(:object_name) { 'device' }

    let(:search_fields) do
      { serialNumber: 'serial_number_1' }
    end

    let(:request_body) do
      {
        input: search_fields,
        deleteBy: 'dedupeFields'
      }
    end

    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        success: true,
        result: [{
          seq: 0,
          status: 'deleted',
          marketoGUID: '1fc49d4fcb86'
        }]
      }
    end

    subject { client.delete_custom_objects(object_name, search_fields) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/customobjects/#{object_name}/delete.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#get_custom_objects' do
    let(:object_name) { 'device' }

    let(:filter_values) do
      [{
        serialNumber: 'serial_number_1'
      }]
    end

    let(:request_body) do
      {
        input: filter_values,
        filterType: 'dedupeFields'
      }
    end

    let(:response_stub) do
      {
        requestId: '1490d#1528af5232',
        result: [{
          seq: 0,
          marketoGUID: '163b231LPr23200e570',
          serialNumber: 'serial_number_1',
          createdAt: '2016-01-23T05:01:01Z',
          updatedAt: '2016-01-29T00:26:00Z'
        }],
        success: true
      }
    end

    subject { client.get_custom_objects(object_name, filter_values) }

    before do
      stub_request(:post, "https://#{host}/rest/v1/customobjects/#{object_name}.json?_method=GET")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
