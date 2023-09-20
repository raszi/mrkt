describe Mrkt::CrudLeads do
  include_context 'with an initialized client'

  describe 'get_lead_by_id' do
    subject { client.get_lead_by_id(id, fields: fields) }

    let(:id) { 200 }

    let(:fields_query) { fields ? "fields=#{fields.join(',')}" : nil }

    before do
      stub_request(:get, "https://#{host}/rest/v1/lead/#{id}.json?#{fields_query}")
        .to_return(json_stub(response_stub))
    end

    context 'when no fields are given' do
      let(:fields) { nil }
      let(:response_stub) do
        {
          requestId: '1134#169a69aae86',
          result: [
            {
              id: id,
              firstName: 'John',
              lastName: 'Snow',
              email: 'jfrost@mrkt.com',
              updatedAt: '2019-03-19T20:39:23Z',
              createdAt: '2019-03-14T13:41:37Z'
            }
          ],
          success: true
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'when an array of fields is given' do
      let(:fields) { %w[email dateOfBirth] }
      let(:response_stub) do
        {
          requestId: '33dd#169a6b5ba65',
          result: [
            {
              id: id,
              email: 'jfrost@mrkt.com',
              dateOfBirth: '1813-03-15'
            }
          ],
          success: true
        }
      end

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#get_leads' do
    subject { client.get_leads(filter_type, filter_values) }

    let(:filter_type) { 'email' }
    let(:filter_values) { %w[user@example.com] }
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            id: 1,
            firstName: 'John',
            lastName: 'Snow',
            email: 'sample@exmaple.com',
            updatedAt: '2015-04-20 05:46:13',
            createdAt: '2015-04-20 05:46:13'
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/leads.json")
        .with(query: { filterType: filter_type, filterValues: filter_values.join(',') })
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#createupdate_leads' do
    subject { client.createupdate_leads(leads, lookup_field: :email) }

    let(:leads) do
      [
        firstName: 'John',
        lastName: 'Snow',
        email: 'sample@example.com'
      ]
    end
    let(:request_body) do
      {
        action: 'createOrUpdate',
        input: [
          {
            firstName: 'John',
            lastName: 'Snow',
            email: 'sample@example.com'
          }
        ],
        lookupField: 'email'
      }
    end
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        success: true,
        result: [
          {
            id: 1,
            status: 'created'
          }
        ]
      }
    end

    before do
      stub_request(:post, "https://#{host}/rest/v1/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }

    context 'with programName' do
      subject { client.createupdate_leads(leads, lookup_field: :email, program_name: 'programNameTest') }

      let(:request_body) do
        {
          action: 'createOrUpdate',
          input: [
            {
              firstName: 'John',
              lastName: 'Snow',
              email: 'sample@example.com'
            }
          ],
          lookupField: 'email',
          programName: 'programNameTest'
        }
      end

      before do
        stub_request(:post, "https://#{host}/rest/v1/leads.json")
          .with(json_stub(request_body))
          .to_return(json_stub(response_stub))
      end

      it { is_expected.to eq(response_stub) }
    end
  end

  describe '#delete_leads' do
    subject { client.delete_leads(leads) }

    let(:leads) { [1] }
    let(:request_body) do
      {
        input: [
          { id: 1 }
        ]
      }
    end
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          { id: 4098, status: 'deleted' }
        ],
        success: true
      }
    end

    before do
      stub_request(:delete, "https://#{host}/rest/v1/leads.json")
        .with(json_stub(request_body))
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#associate_lead' do
    subject(:action) { client.associate_lead(id, cookie) }

    let(:id) { 1 }
    let(:cookie) { 'id:561-HYG-937&token:_mch-marketo.com-1427205775289-40768' }
    let(:request_stub) { {} }

    before do
      stub_request(:post, "https://#{host}/rest/v1/leads/#{id}/associate.json?#{URI.encode_www_form(cookie: cookie)}")
        .with(json_stub(request_stub))
        .to_return(json_stub(response_stub))
    end

    context 'with an existing lead id' do
      let(:response_stub) do
        {
          requestId: 'c245#14cd6830ae2',
          result: [],
          success: true
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'with a non-existing lead id' do
      let(:response_stub) do
        {
          requestId: 'c245#14cd6830ae2',
          success: false,
          errors: [
            {
              code: '1004',
              message: "Lead '1' not found"
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::LeadNotFound)
      end
    end
  end

  describe '#merge_leads' do
    subject(:action) { client.merge_leads(id, losing_lead_ids) }

    let(:id) { 1 }
    let(:losing_lead_ids) { [2, 3, 4] }
    let(:request_stub) { {} }

    before do
      params = Faraday::Utils::ParamsHash.new
      params[:mergeInCRM] = false
      params[:leadIds] = losing_lead_ids.join(',') if losing_lead_ids

      stub_request(:post, "https://#{host}/rest/v1/leads/#{id}/merge.json?#{params.to_query}")
        .with(json_stub(request_stub))
        .to_return(json_stub(response_stub))
    end

    context 'with existing leads' do
      let(:response_stub) do
        {
          requestId: 'c245#14cd6830ae2',
          success: true
        }
      end

      it { is_expected.to eq(response_stub) }
    end

    context 'with a non-existing lead id' do
      let(:response_stub) do
        {
          requestId: 'c245#14cd6830ae2',
          success: false,
          errors: [
            {
              code: '1004',
              message: "Lead '1' not found"
            }
          ]
        }
      end

      it 'raises an Error' do
        expect { action }.to raise_error(Mrkt::Errors::LeadNotFound)
      end
    end
  end

  describe '#describe_lead' do
    subject { client.describe_lead }

    let(:response_stub) do
      {
        requestId: '5c9e#169a68fa806',
        result: [
          {
            id: 4,
            displayName: 'Company Name',
            dataType: 'string',
            length: 255,
            rest: {
              name: 'company',
              readOnly: false
            },
            soap: {
              name: 'Company',
              readOnly: false
            }
          },
          {
            id: 56,
            displayName: 'Email Address',
            dataType: 'email',
            length: 255,
            rest: {
              name: 'email',
              readOnly: false
            },
            soap: {
              name: 'Email',
              readOnly: false
            }
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/rest/v1/leads/describe.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end
end
