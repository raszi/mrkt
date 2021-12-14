describe Mrkt do
  include_context 'with an initialized client'

  it { is_expected.to respond_to(:get, :post, :delete) }
end
