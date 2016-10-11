$:.push File.expand_path('../lib', __FILE__)

require 'utils/version'

Gem::Specification.new do |s|
  s.name        = 'onapp-utils'
  s.version     = Utils::VERSION
  s.authors     = ['OnApp Devs']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Summary of utils.'
  s.description = 'Description of utils.'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.rdoc']

  s.add_dependency 'activesupport', '3.2.22'

  s.add_development_dependency 'mysql2', '~>0.3.14'
  s.add_development_dependency 'activerecord', '3.2.22'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-its'
end
