require 'active_support'

module Utils
  require 'utils/version'
  require_relative 'utils/ar' if defined?(ActiveRecord)
  require_relative 'utils/numeric'
  require_relative 'utils/time'
  require_relative 'utils/size'
  require_relative 'utils/api'
  require_relative 'utils/i18n'
  require_relative 'utils/hash'
  require_relative 'utils/yaml'
end