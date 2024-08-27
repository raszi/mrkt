lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mrkt/version'

Gem::Specification.new do |spec|
  spec.name          = 'mrkt'
  spec.version       = Mrkt::VERSION
  spec.authors       = ['KARASZI István', 'Jacques Lemieux']
  spec.email         = ['github@spam.raszi.hu', 'jalemieux@gmail.com']
  spec.summary       = 'Marketo REST API Facade'
  spec.description   = 'This gem helps you to use the Marketo REST API'
  spec.homepage      = 'https://github.com/raszi/mrkt'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'faraday', '>= 1.10', '< 3'
  spec.add_dependency 'faraday-multipart'
end
