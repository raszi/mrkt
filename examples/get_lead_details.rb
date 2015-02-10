$:.unshift(File.expand_path('../../lib/', __FILE__))
require_relative '../lib/mkto_rest'
# or require 'mkto_gem' if you installed the gem

require 'yaml'

=begin
This script looks for the hostname, client id and key in .mktorest.
Create that file with the following (yaml) format:

    ---
    :hostname: ''
    :client_id: ''
    :client_secret: ''

set your hostname, client id and key to the right values.
=end

config_path = File.expand_path(File.join(File.dirname(__FILE__),'..', '.mktorest'))

if File.exists? config_path
  config = YAML::load_file(config_path)
else
  print <<-EOF
"Set your hostname, client id and key in #{config_path} in this format:

#{{ hostname: '', client_id: '', client_secret: '' }.to_yaml}

EOF
  exit 1
end
if ARGV.size < 1
  print "#{__FILE__} <lead_email> \n    e.g.: #{__FILE__} john@acme.com \n\n"
  exit 1
end

attr_v = ARGV.shift
values = {}
ARGV.each do |pair|
  k, v = pair.split('=')
  values[k] = v
end



client = MktoRest::Client.new(host: config[:hostname], client_id: config[:client_id], client_secret: config[:client_secret])

#client.debug = true #verbose output, helps debugging

# find leads, updated fields.
client.get_leads :email, attr_v do |lead|
  p "id: #{lead.id}, email: #{lead.email}"
end



