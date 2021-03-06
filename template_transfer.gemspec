# coding utf-8
lib = File.expand_path( '../lib', __FILE__ )
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'template_transfer/version'

Gem::Specification.new do |s|
  s.name          = 'template_transfer'
  s.version       = TemplateTransfer::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Tommy Leblanc']
  s.email         = ['tleblanc@changehealthcare.com']
  s.summary       = 'Sendgrid template transfer script'
  s.description   = 'Automated script for transfer/setup of templates'
  s.homepage      = 'http://www.changehealthcare.com'
  s.files         = Dir.glob('{bin,lib,templates}/**/*') + %w(README.md)
  s.require_path  = 'lib'
  s.executables   = ['template_transfer']
  s.license       = 'MIT'

  # Runtime dependencies
  s.add_runtime_dependency 'rspec', '~> 3.2'
  s.add_runtime_dependency 'mocha', '~> 1.1'

  # Development dependencies
  s.add_development_dependency 'pry',   '~> 0'
  s.add_development_dependency 'json',  '~> 2.2.0'
  s.add_development_dependency 'rspec', '~> 3.2'
end