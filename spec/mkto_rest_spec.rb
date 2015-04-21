describe Mrkt do
  include_context 'initialized client'

  it { is_expected.to respond_to(:get, :post, :delete) }
end
