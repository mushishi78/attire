# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attire/version'

Gem::Specification.new do |spec|
  spec.name          = 'attire'
  spec.version       = Attire::VERSION
  spec.authors       = ['Max White']
  spec.email         = ['mushishi78@gmail.com']
  spec.summary       = 'Convenience methods to remove some boiler plate in defining classes.'
  spec.homepage      = 'https://github.com/mushishi78/attire'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec', '~> 3.1'
end
