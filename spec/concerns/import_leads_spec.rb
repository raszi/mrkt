require 'csv'
require 'tempfile'

describe Mrkt::ImportLeads do
  include_context 'with an initialized client'

  describe '#import_lead' do
    subject { client.import_lead(tempfile) }

    let(:tempfile) { Tempfile.new(%w[import-leads csv]) }
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        success: true,
        result: [
          {
            batchId: 1,
            status: 'Importing'
          }
        ]
      }
    end

    before do
      CSV.open(tempfile, 'wb') do |csv|
        csv << %w[email firstName lastName]
        csv << %w[sample@example.com John Snow]
      end

      stub_request(:post, "https://#{host}/bulk/v1/leads.json")
        .with(headers: { content_type: %r{multipart/form-data; boundary=\S+} })
        .to_return(json_stub(response_stub))
    end

    after do
      tempfile.unlink
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_lead_status' do
    subject { client.import_lead_status(1) }

    let(:id) { 1 }
    let(:response_stub) do
      {
        requestId: 'c245#14cd6830ae2',
        result: [
          {
            batchId: id,
            status: 'Importing',
            numOfLeadsProcessed: 4,
            numOfRowsFailed: 1,
            numOfRowsWithWarning: 0,
            message: 'Import completed with errors, 4 records imported (4 members), 1 failed'
          }
        ],
        success: true
      }
    end

    before do
      stub_request(:get, "https://#{host}/bulk/v1/leads/batch/#{id}.json")
        .to_return(json_stub(response_stub))
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_lead_failures' do
    subject { client.import_lead_failures(1) }

    let(:id) { 1 }
    let(:response_stub) { '' }

    before do
      stub_request(:get, "https://#{host}/bulk/v1/leads/batch/#{id}/failures.json")
        .to_return(headers: { content_length: 0 })
    end

    it { is_expected.to eq(response_stub) }
  end

  describe '#import_lead_warnings' do
    subject { client.import_lead_warnings(1) }

    let(:id) { 1 }
    let(:response_stub) { '' }

    before do
      stub_request(:get, "https://#{host}/bulk/v1/leads/batch/#{id}/warnings.json")
        .to_return(headers: { content_length: 0 })
    end

    it { is_expected.to eq(response_stub) }
  end
end
