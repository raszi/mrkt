require 'mkto_rest'


client_id = ''
client_secret = ''
host = ''
client = MktoRest::Client.new(host, client_id, client_secret)
client.authenticate

# get lead data by email
leads = client.get_leads(:email, ['jacques@marketo.com'])

leads.each do |l|
  p "id: #{l.id}, email: #{l.email}"
end

# update 

leads = client.update_lead(11278906, "Production")
p leads

