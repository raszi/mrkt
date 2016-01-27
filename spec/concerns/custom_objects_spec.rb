describe Mrkt::CustomObjects do
  include_context 'initialized client'

  describe '#get_list_of_custom_objects' do
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          { name: 'device_c',
            displayName: 'Device',
            description: 'this is a device object',
            createdAt: '2016-01-23T00:51:18Z',
            updatedAt: '2016-01-23T00:51:18Z',
            idField: 'marketoGUID',
            dedupeFields: ['serialNumber'],
            searchableFields: [['serialNumber'], ['marketoGUID']],
            relationships: [{
                field: 'email',
                type: 'child',
                relatedTo: { name: 'Lead', field: 'email' }
            }],
           },
           {
             name: 'manufacturer_c',
             displayName: 'Manufacturer',
             createdAt: '2016-01-23T00:55:18Z',
             updatedAt: '2016-01-23T00:55:18Z',
             idField: 'marketoGUID',
             dedupeFields: ['name'],
             searchableFields: [['name'], ['marketoGUID']],
             relationships: [{
                 field: 'email',
                 type: 'child',
                 relatedTo: { name: 'Lead', field: 'email' }
              }]
           }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/customobjects.json")
        .with(query: {"names" =>  object_names.join(',')})
        .to_return(json_stub(response_stub))
    end

    subject { client.get_list_of_custom_objects(object_names) }

    context 'with empty object names' do
      let(:object_names) { [] }

      it { is_expected.to eq(response_stub) }
    end

    context 'with valid object names' do
      let(:object_names) { %w(device_c manufacturer_c)  }

      it { is_expected.to eq(response_stub) }
    end
  end

end
