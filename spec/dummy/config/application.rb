require File.expand_path('../boot', __FILE__)

require 'active_record/railtie'
require 'action_mailer'

Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
  end
end