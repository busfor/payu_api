# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payu_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'payu_api'
  spec.version       = PayuAPI::VERSION
  spec.authors       = ['Roman Khrebtov']
  spec.email         = ['roman@alltmb.ru']

  spec.summary       = 'Ruby wrapper for PayU REST API'
  spec.description   = 'Ruby wrapper for PayU REST API'
  spec.homepage      = 'https://github.com/busfor/payu_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-initializer', '~> 0.4'
  spec.add_dependency 'faraday', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'simplecov', '~> 0.12'
  spec.add_development_dependency 'rubocop', '~> 0.42'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'faraday-detailed_logger'
end
