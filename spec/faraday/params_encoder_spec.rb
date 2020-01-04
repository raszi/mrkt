describe Mrkt::Faraday::ParamsEncoder do
  describe '.encode' do
    let(:params) do
      {
        string: 'foobar',
        number: 1,
        boolean: true,
        array: [1, 2, 3]
      }
    end

    subject { described_class.encode(params) }

    it { is_expected.to eq(Faraday::Utils::ParamsHash.new.merge(params.merge(array: '1,2,3')).to_query) }
  end

  describe '.decode' do
    let(:value) { 'foo=foo&bar=bar' }

    subject { described_class.decode(value) }

    it { is_expected.to eq('foo' => 'foo', 'bar' => 'bar') }
  end
end
