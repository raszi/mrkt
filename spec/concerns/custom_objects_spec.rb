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

  describe '#describe_custom_object' do
    let(:response_stub) {
      {:requestId=>"eeef#152858b17d2",
        :result=>
          [{:name=>"device_c",
            :displayName=>"Device",
            :description=>"this is a device object",
            :createdAt=>"2016-01-23T00:51:18Z",
            :updatedAt=>"2016-01-23T00:51:18Z",
            :idField=>"marketoGUID",
            :dedupeFields=>["serialNumber"],
            :searchableFields=>[["serialNumber"], ["marketoGUID"]],
            :relationships=>
              [{:field=>"serialNumber",
                :type=>"child",
                :relatedTo=>{:name=>"Lead", :field=>"serialNumber"}}],
            :fields=>
              [{:name=>"createdAt",
                :displayName=>"Created At",
                :dataType=>"datetime",
                :updateable=>false},
                {:name=>"marketoGUID",
                  :displayName=>"Marketo GUID",
                  :dataType=>"string",
                  :length=>36,
                  :updateable=>false},
                {:name=>"updatedAt",
                  :displayName=>"Updated At",
                  :dataType=>"datetime",
                  :updateable=>false},

                {:name=>"serialNumber",
                  :displayName=>"serial number",
                  :dataType=>"string",
                  :length=>255,
                  :updateable=>true}
               ]}],
        :success=>true}

    }

    before do
      stub_request(:get, "https://#{host}/rest/v1/customobjects/#{object_name}/describe.json")
        .to_return(json_stub(response_stub))
    end

    subject { client.describe_custom_object(object_name) }

    context "when the object name is valid" do
      let(:object_name) { :device_c }

      it { is_expected.to eq(response_stub) }
    end

    context "when the object name is invalid" do
      let(:object_name) {[]}

      it 'should raise an Error' do
        object_name = []
        expect { subject }.to raise_error(Mrkt::Errors::Unknown)
      end
    end

    context "when no object name given" do
      let(:object_name) { nil }

      it 'should raise error' do
        expect { subject }.to raise_error(Mrkt::Errors::Unknown)
      end
    end
  end
end
