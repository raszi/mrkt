describe Mrkt::Errors do
  describe '.find_by_response_code' do
    subject { described_class.find_by_response_code(code) }

    context 'when the code is' do
      context 'known' do
        let(:code) { 413 }

        it 'should return the mapped error class' do
          is_expected.to eq(Mrkt::Errors::RequestEntityTooLarge)
        end
      end

      context 'unknown' do
        let(:code) { 7331 }

        it { is_expected.to eq(Mrkt::Errors::Error) }
      end
    end
  end
end
