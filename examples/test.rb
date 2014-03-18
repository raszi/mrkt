require 'mkto_rest'



client = MktoRest::Client.new(host, client_id, client_secret)
client.authenticate

# get lead data by email
leads = client.get_leads(:email, ['jacques@marketo.com'])

leads.each do |l|
  p "id: #{l.id}, email: #{l.email}"
end

# update 

leads = client.update_lead(11278906, { "CS-EmailNames" => "Production", "CS-Login" => "deployer@marketo.com" } )
p leads

