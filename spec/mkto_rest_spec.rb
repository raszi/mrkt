require 'spec_helper'

require File.expand_path(File.join(File.dirname(__FILE__), 'mkto_rest_helper.rb'))


describe MktoRest do

  before(:each) do
    @client_id = 'id'
    @client_key = 'key'
    @hostname = 'dummy.mktorest.com'
    @token = 'token'

    @client = MktoRest::Client.new(host: @hostname, client_id: @client_id, client_secret: @client_key)
    @authenticated_client = MktoRest::Client.new(host: @hostname,client_id:  @client_id, client_secret: @client_key)
    @authenticated_client.__auth(@token)

    @lead1 = MktoRest::Lead.new(@authenticated_client, { name: 'john', email: 'john@acme.com', id: 1} )
  end



  describe "v1 API" do
    context "#authenticated?" do
      context "before authentication" do
        it "should be false" do
          expect(@client.authenticated?) == false
        end
      end
      context "after authentication" do
        it "should be true" do
          expect(@authenticated_client.authenticated?) == true
        end
      end
    end
  
    # this section tests that the gem code can parse the documented response correctly.
    # repsonses samples are in responses_samples/*.json
    describe "authentication" do
      it "parses response" do
        set_authentication_stub_request(@hostname, @client_id, @client_key, @token)
        expect { @client.authenticate }.not_to raise_error
        expect(@client.token).to_not be_nil
        expect(@client.expires_in).to_not be_nil
        expect(@client.valid_until).to_not be_nil
        expect(@client.token_type).to_not be_nil
        expect(@client.scope).to_not be_nil
      end  
    end
    describe "leads operations" do
      it "uses correct HTTP GET body and headers" do
        set_get_leads_stub_request('email', 'john@acme.com', @hostname, @token) 
        expect { @authenticated_client.get_leads :email, 'john@acme.com' }.not_to raise_error
      end
    end

  end

  describe "lead" do
    let(:sample_lead){
      [{  
         "email" => "kjashaedd-1@klooblept.com",
         "firstName" => "Kataldar-1",
         "postalCode" => "04828"
      }]
    }
    let(:sample_leads) {
      [{  
         "email" => "kjashaedd-1@klooblept.com",
         "firstName" => "Kataldar-1",
         "postalCode" => "04828"
      },
      {  
         "email" => "kjashaedd-2@klooblept.com",
         "firstName" => "Kataldar-2",
         "postalCode" => "04828"
      },
      {  
         "email" => "kjashaedd-3@klooblept.com",
         "firstName" => "Kataldar-3",
         "postalCode" => "04828"
      }]
    }
    let(:partition){ 'bizdev'}

    it "can be updated by id" do
      set_update_lead_stub_request(:id, 1, { 'someFieldX' => 'new_value' }, @hostname, @token)
      @lead1.update({ 'someFieldX' => 'new_value' }, :id)
    end
    it "can be updated by email" do
      set_update_lead_stub_request(:email, @lead1.email, { 'someFieldX' => 'new_value' }, @hostname, @token)
      @lead1.update({ 'someFieldX' => 'new_value' }, :email)
    end

    it "one can be created with email but w/out partition" do
      set_create_leads_stub_request(sample_lead, @hostname, @token)
      @authenticated_client.create_leads(sample_lead);
    end

    it "multiple leads can be created with emails but w/out partition" do
      set_create_leads_stub_request(sample_leads, @hostname, @token)
      @authenticated_client.create_leads(sample_leads);
    end

    it  "multiple can be created with email and partition" do
      set_create_leads_stub_request(sample_leads, @hostname, @token, { :partition => partition })
      @authenticated_client.create_leads(sample_leads, 'createOnly', partition);
    end

  end

  
  describe "client" do
    describe "get leads" do
      it "should return leads when no block is passed" do
        l = MktoRest::Lead.new(@authenticated_client, { id: 1, email: 'joe@acme.com'})
        set_get_leads_stub_request('email', l.email, @hostname, @token) 
        leads = @authenticated_client.get_leads :email, l.email
        expect(leads.size) == 1
      end
      it "should execute the block passed in on each leads" do
        l = MktoRest::Lead.new(@authenticated_client, { id: 1, email: 'joe@acme.com'})
        set_get_leads_stub_request('email', l.email, @hostname, @token) 
        leads = @authenticated_client.get_leads :email, l.email do |lead|
          lead.email = "newemail@acme.com"
        end
        expect(leads.size) == 1
        expect(leads.first.email) == "newemail@acme.com"
      end      
    end
  end
end