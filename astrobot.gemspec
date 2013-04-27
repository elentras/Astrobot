# -*- encoding: utf-8 -*-
require File.expand_path('../lib/astrobot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeremy Mortelette"]
  gem.email         = ["mortelette.jeremy@gmail.com"]
  gem.description   = "Large ruby wrapper for the Transmission RPC API base on Fernando Guillen's gem transmission_api"
  gem.summary       = "Large ruby wrapper for the Transmission RPC API"
  gem.homepage      = "https://github.com/fguillen/TransmissionApi"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "astrobot"
  gem.require_paths = ["lib"]
  gem.version       = Astrobot::Version::VERSION

  gem.add_dependency "httparty", "0.9.0"

  gem.add_development_dependency "mocha", "0.13.0"
end
