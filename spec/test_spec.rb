require 'spec_helper'


describe MktoRest do
  it "brouillon" do
    stub_request(:any, "www.example.com")
    Net::HTTP.get("www.example.com", "/")    # ===> Success
  end
end