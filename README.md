# MktoRest

This gem provides some level of abstraction to Marketo REST APIs. Please note that this gem is alpha quality. 

## Installation

Add this line to your application's Gemfile:

    gem 'mkto_rest', path: "path_to_code"

Or you can build the gem:

    $ rake install mkto_rest

and include it in your app/gem's Gemfile (this works locally only):

    gem 'mkto_rest'    


## Prerequisites

Get the following from your Marketo admin:
* hostname, i.e. \<munchkin_id\>.mktorest.com
* client id, e.g. '4567e1cdf-0fae-4685-a914-5be45043f2d8'
* client secret, e.g. '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt'

## Usage

Create a client and authenticate,

    client = MktoRest::Client.new(
        host: '123-abc-123.mktorest.com', 
        client_id:  '4567e1cdf-0fae-4685-a914-5be45043f2d8', 
        client_secret: '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt')

If you need verbosity during troubleshooting, set the client to debug mode

    client.debug = true

get leads matching an email, print their id and email:
    
    client.get_leads :email, 'sammy@acme.com' do |lead|
      p "id: #{l.id}, email: #{l.email}"
    end

fetch a lead and update one of its value:

    client.get_leads :email, 'john@bigcorp.com' do |lead|
      lead.update({ 'CustomField' => 'New Value', 'AnotherField' => 'New value' })
    end
  
updating a lead, using id, email, etc.

    new_values = { 'Firstname' => 'Jeanne' }
    leads = client.get_leads :email, 'jane@scorp.com' 
    # update using id
    leads.first.update(new_values, :id)
    # update using email
    leads.first.update(new_values, :email)
  
  creating 2 new leads:

      new_leads = [
                    {
                      email: 'jane@scorp.com',
                      firstName: 'Jane Doe'
                    },
                    {
                      email: 'joe@scorp.com',
                      firstName: 'Joe Doe'
                    }
                  ]
      client.create_leads new_leads

## Set up

    bundle install

## Build and Install the gem

    bundle exec rake install

## Run Tests

    bundle exec rake spec

## Examples

First create the configuration file .mktorest which should contain your client id and key, and hostname, e.g.:

    ---
    :hostname: '215-CIJ-720.mktorest.com'
    :client_id: 'f950fg3e-80g5-42cc-9dc4-5eb054cc0836
    :client_secret: 'dnGn25KLrtgssy6ecurMPnqQx61vykje'

You can then run the example:
  
    bundle exec ruby examples/update_lead.rb


Running it with no arguments will display the usage.    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
