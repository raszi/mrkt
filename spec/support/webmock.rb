require 'webmock/rspec'

RSpec.configure do |config|
  def json_stub(content_stub)
    {
      headers: { content_type: 'application/json' },
      body: JSON.generate(content_stub)
    }
  end

  if ENV['CODECLIMATE_REPO_TOKEN']
    config.after(:suite) do
      WebMock.disable_net_connect!(allow: 'codeclimate.com')
    end
  end
end
