require 'mkto_rest'
require 'yaml'

config_path = File.expand_path(File.join(File.dirname(__FILE__),'..', '.mktorest'))

if File.exists? config_path
  config = YAML::load_file(config_path) 
else
  File.open(config_path, 'w') {|f| f.write({ hostname: '', client_id: '', client_secret: '' }.to_yaml) }
  p "Set your hostname, client id and key in #{config_path}"
  exit 1
end
if ARGV.size < 2 or ARGV[0].include?('=')
  print "#{__FILE__} <lead_email> <key1:value2> <key2:value2> ...\n    e.g.: #{__FILE__} CS-Login=john@acme.com CS-EmailNames=Production\n\n"
  exit 1
end

email = ARGV.shift
values = {}
ARGV.each do |pair|
  k, v = pair.split('=')
  values[k] = v
end


begin

  client = MktoRest::Client.new(config[:hostname], config[:client_id], config[:client_secret])

  client.debug = true #verbose output, helps debugging 

  client.authenticate

  # get lead data by email
  client.get_leads :email, email do |lead|
    p "id: #{lead.id}, email: #{lead.email}"
  end

  # find leads, updated fields.
  client.get_leads :email, email do |lead|
    lead.update(values)
  end

rescue Exception=>e
  p "error: #{e.message}"
end


