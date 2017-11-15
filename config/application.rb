require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Openregister gem
require 'openregister'
require 'cf-app-utils'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CustodianUpdateTool
  class Application < Rails::Application
    if ENV.key?('VCAP_SERVICES')
      cups_env = CF::App::Credentials.find_by_service_name('managing-registers-environment-variables')
      if cups_env.present?
        cups_env.each { |k, v| ENV[k] = v }
      end
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'London'
    config.active_record.default_timezone = :local
    config.autoload_paths += %W["#{config.root}/app/validators/"]

    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

    # TODO: Refactor our code to not need this
    config.action_controller.permit_all_parameters = true

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end

    Rails.application.configure do
      config.lograge.formatter = Lograge::Formatters::Json.new
      config.lograge.enabled = true

      config.lograge.custom_options = lambda do |_event|
        { name: 'RMT' }
      end
    end
  end
end
