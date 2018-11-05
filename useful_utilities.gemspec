$:.push File.expand_path('lib', __dir__)

require 'useful_utilities/version'

Gem::Specification.new do |s|
  s.name = 'useful_utilities'
  s.version = UsefulUtilities::VERSION
  s.authors = ['OnApp Ltd.']
  s.email = 'onapp@onapp.com'
  s.homepage = 'https://github.com/OnApp/useful_utilities'
  s.summary = 'Helpful methods for time, sizes, hashes etc.'
  s.license = 'Apache 2.0'
  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md, LICENSE']
  s.required_ruby_version = '>= 2.2.2'
  s.has_rdoc = 'yard'

  s.description = <<-EOF
    A bunch of useful modules to work with time/size constants/hashes
  EOF

  s.add_dependency 'activesupport', ">= 5.0.1"
  s.add_dependency 'activerecord', ">= 5.0.1"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-its'
end
