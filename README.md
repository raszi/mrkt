# Mrkt

[![Build Status](https://travis-ci.org/raszi/mrkt.svg?branch=master)](https://travis-ci.org/raszi/mrkt)
[![Code Climate](https://codeclimate.com/github/raszi/mrkt/badges/gpa.svg)](https://codeclimate.com/github/raszi/mrkt)
[![Test Coverage](https://codeclimate.com/github/raszi/mrkt/badges/coverage.svg)](https://codeclimate.com/github/raszi/mrkt)
[![Gem Version](https://badge.fury.io/rb/mrkt.svg)](https://badge.fury.io/rb/mrkt)
[![Total Downloads](https://badgen.net/rubygems/dt/mrkt)](https://rubygems.org/gems/mrkt)

This gem provides some level of abstraction to Marketo REST APIs. Please note that this gem is alpha quality.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mrkt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mrkt


## Prerequisites

Get the following from your Marketo admin:

* hostname, i.e. `'123-abc-123.mktorest.com'`
* client id, e.g. `'4567e1cdf-0fae-4685-a914-5be45043f2d8'`
* client secret, e.g. `'7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt'`
* partner id, e.g. `'335b1c91511b8d8b49c7bbf66f53288f16f37b60_a0147938d3135f8ddb5a75850ea3c39313fd23c4'` (optional)


## Usage

### Create a client and authenticate

```ruby
client = Mrkt::Client.new(
  host: '123-abc-123.mktorest.com',
  client_id:  '4567e1cdf-0fae-4685-a914-5be45043f2d8',
  client_secret: '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt',
  partner_id: '335b1c91511b8d8b49c7bbf66f53288f16f37b60_a0147938d3135f8ddb5a75850ea3c39313fd23c4' # optional 
)
```

If you need verbosity during troubleshooting, enable debug mode:

```ruby
client = Mrkt::Client.new(
  host: '123-abc-123.mktorest.com',
  client_id:  '4567e1cdf-0fae-4685-a914-5be45043f2d8',
  client_secret: '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt',
  debug: true,
  logger: ::Logger.new("log/marketo.log"), # optional, defaults to Faraday default of logging to STDOUT
  log_options: {bodies: true}) # optional, defaults to Faraday default of only logging headers
```

### Retry authentication

Since the Marketo API provides API access keys with a validity of 3600 seconds, if you are running an hourly cronjob it's possible that your subsequent call receives the same key from the previous hour, which is then immediately expired. If this is the case, you can configure the client to retry until receiving a valid key:

```ruby
client = Mrkt::Client.new(
  host: '123-abc-123.mktorest.com',
  client_id:  '4567e1cdf-0fae-4685-a914-5be45043f2d8',
  client_secret: '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt',
  retry_authentication: true,
  retry_authentication_count: 3, # default: 3
  retry_authentication_wait_seconds: 1, # default: 0
  )
```

This is turned off by default.

### Get leads matching an email, print their id and email
    
```ruby
response = client.get_leads(:email, ['sammy@acme.com'])
response[:result].each do |result|
  p "id: #{result[:id]}, email: #{result[:email]}"
end
```

### Create/Update leads

```ruby
response = client.createupdate_leads([{ email: 'sample@example.com', firstName: 'John' }], lookup_field: :email)
response[:result].each do |result|
  p "id: #{result[:id]}, email: #{result[:email]}"
end
```

### Run a smart campaign on existing leads
```ruby
campaign_id = 42        # this is the ID of the campaign
lead_ids    = [1, 2, 4] # these are the leads who receive the campaign
tokens      = [{        # these tokens (optional) are then passed to the campaign
                 name:  '{{my.message}}',
                 value: 'Updated message'
               }, {
                 name:  '{{my.other token}}',
                 value: 'Value for other token'
               }]
client.request_campaign(campaign_id, lead_ids, tokens) # tokens can be omited
=> { requestId: 'e42b#14272d07d78', success: true }
```

## Run Tests

    $ bundle exec rspec


## Examples

Examples are in the `spec/` directory.


## Contributing

1. Fork it ( https://github.com/raszi/mrkt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
