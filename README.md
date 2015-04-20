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

### Create a client and authenticate,

```ruby
client = MktoRest::Client.new(
    host: '123-abc-123.mktorest.com', 
    client_id:  '4567e1cdf-0fae-4685-a914-5be45043f2d8', 
    client_secret: '7Gn0tuiHZiDHnzeu9P14uDQcSx9xIPPt')
```

If you need verbosity during troubleshooting, set the client to debug mode

```ruby
client.debug = true
```

### Get leads matching an email, print their id and email:
    
```ruby
response = client.get_leads :email, 'sammy@acme.com'
response.body[:result].each do |result|
  p "id: #{result[:id]}, email: #{result[:email]}"
end
```

### Create/Update leads

```ruby
response = client.createupdate_leads([ email: 'sample@example.com', firstName: 'John' ], lookup_field: :email)
response.body[:result].each do |result|
  p "id: #{result[:id]}, email: #{result[:email]}"
end
```


## Set up

```sh
bundle install
```


## Build and Install the gem

```sh
bundle exec rake install
```


## Run Tests

```sh
bundle exec rake spec
```


## Examples

Examples are in the `spec/` directory.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
