$:.push File.expand_path('lib', __dir__)

require 'useful_utilities/version'

Gem::Specification.new do |s|
  s.name        = 'useful_utilities'
  s.version     = UsefulUtilities::VERSION
  s.authors     = ['OnApp Ltd.']
  s.email       = ['onapp@onapp.com']
  s.summary     = 'Summary of utils.'
  s.description = 'Description of utils.'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.rdoc']

  s.add_dependency 'activesupport'

  s.add_development_dependency 'timecop'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'fuubar'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-its'
end
