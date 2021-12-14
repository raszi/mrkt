describe Mrkt::Faraday::ParamsEncoder do
  describe '.encode' do
    subject { described_class.encode(params) }

    let(:params) do
      {
        string: 'foobar',
        number: 1,
        boolean: true,
        array: [1, 2, 3]
      }
    end

    it { is_expected.to eq(Faraday::Utils::ParamsHash.new.merge(params.merge(array: '1,2,3')).to_query) }
  end

  describe '.decode' do
    subject { described_class.decode(value) }

    let(:value) { 'foo=foo&bar=bar' }

    it { is_expected.to eq('foo' => 'foo', 'bar' => 'bar') }
  end
end
