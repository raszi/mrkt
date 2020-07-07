describe Mrkt::FaradayMiddleware::ExceptionalResponse do
  before do
    response = lambda { |env|
      [status, {'Content-Type' => content_type}, body]
    }
    @conn = Faraday.new do |b|
      b.use Mrkt::FaradayMiddleware::ExceptionalResponse
      b.adapter :test do |stub|
        stub.get('/', &response)
      end
    end
  end

  context 'with application/json and with server error' do
    let(:content_type) { 'application/json' }
    let(:status) { 500 }
    let(:body) { '{}' }

    it 'does nothing' do
      expect(@conn.get('/').body).to eq body
    end
  end

  context 'with non json content-type and with server error' do
    let(:content_type) { 'text/plain' }
    let(:status) { 500 }
    let(:body) { 'something wrong' }

    it { expect { @conn.get('/') }.to raise_error(Mrkt::Errors::Unknown) }
  end

  context 'with non json content-type but with successful response' do
    let(:content_type) { 'text/html' }
    let(:status) { 200 }
    let(:body) { 'ok' }

    it 'does nothing' do
      expect(@conn.get('/').body).to eq body
    end
  end
end
