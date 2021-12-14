describe Mrkt::Errors do
  describe '.find_by_response_code' do
    subject(:actual) { described_class.find_by_response_code(code) }

    context 'when the code is known' do
      let(:code) { 413 }

      it 'returns the mapped error class' do
        expect(actual).to eq(Mrkt::Errors::RequestEntityTooLarge)
      end
    end

    context 'when the code is unknown' do
      let(:code) { 7331 }

      it { is_expected.to eq(Mrkt::Errors::Error) }
    end
  end
end
