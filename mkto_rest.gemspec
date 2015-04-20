# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mkto_rest/version'

Gem::Specification.new do |spec|
  spec.name          = "mkto_rest"
  spec.version       = MktoRest::VERSION
  spec.authors       = ["jalemieux@gmail.com"]
  spec.email         = ["jalemieux@gmail.com"]
  spec.description   = %q{MKTO REST API Facade}
  spec.summary       = %q{MKTO REST API Facade}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday_middleware', '~> 0.9.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'webmock', '~> 1.21.0'

  spec.add_development_dependency 'pry-byebug', '~> 3.1.0'
end
