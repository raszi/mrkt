require 'webmock/rspec'

RSpec.configure do |config|
  def json_stub(content_stub)
    {
      headers: { content_type: 'application/json' },
      body: JSON.generate(content_stub)
    }
  end
end
