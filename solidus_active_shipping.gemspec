# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY

  s.name        = 'solidus_active_shipping'
  s.version     = '0.0.1'
  s.authors     = ["Anthony D'Addeo"]
  s.email       = 'anthony@personalwine.com'
  s.homepage    = 'http://github.com/pervino/solidus_active_shipping'
  s.summary     = 'Solidus extension for providing shipping methods that wrap the active_shipping plugin.'
  s.description = 'Solidus extension for providing shipping methods that wrap the active_shipping plugin.'
  s.required_ruby_version = '>= 2.1.0'
  s.rubygems_version      = '>= 1.8.23'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('solidus_core', '~> 1.3.0.alpha')
  s.add_dependency('active_shipping', '~> 1.4.2')
  s.add_development_dependency 'pry'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'simplecov'
end
