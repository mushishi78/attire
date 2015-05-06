# coding: utf-8
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name         = 'attire'
  s.version      = version
  s.author       = 'Max White'
  s.email        = 'mushishi78@gmail.com'
  s.homepage     = 'https://github.com/mushishi78/attire'
  s.summary      = 'Mixins to remove some boiler plate in defining classes.'
  s.license      = 'MIT'
  s.files        = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  s.require_path = 'lib'
  s.add_development_dependency 'rspec', '~> 3.1', '>= 3.1.0'
end
