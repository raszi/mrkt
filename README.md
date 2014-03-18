# MktoRest

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mkto_rest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mkto_rest

## Prerequisites
Get the follwing from your Marketo admin:
* hostname, i.e. <munchkin_id>.mktoprest.com
* client id, e.g. '4567e1cdf-0fae-4685-a914-5be45043f2d8'
* client secret, e.g. '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt'

## Usage

Create a client and authenticate:

    client = MktoRest::Client.new(
      '123-abc-123.mktorest.com',
      '4567e1cdf-0fae-4685-a914-5be45043f2d8'', 
      '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt')

find a lead id from an email:
    
    client.get_leads('sammy@acme.com')

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
