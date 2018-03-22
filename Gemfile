# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby File.read('.ruby-version').chomp

gem 'rails', '5.1.5'

# Database
gem 'pg', '~> 0.18'

# Server
gem 'puma', '~> 3.0'

# Assets
gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'haml-rails', '~> 0.9'

# GOV.UK UI
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder'
gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template'

# API client for GOV.UK Registers
gem 'govuk-registers-api-client'

# Email and Text Notifications
gem 'govuk_notify_rails'

# Deploying jobs
gem 'sidekiq'

# User authentication
gem 'cancancan'
gem 'devise'
gem 'devise_invitable'

# form helpers
gem 'nested_form_fields'
gem 'timeliness', '~> 0.3.8'

# cloudfoundry
gem 'cf-app-utils', '~> 0.6'
gem 'lograge', '~> 0.7.1'


group :development, :test do
  gem 'capybara'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'govuk-lint', '~> 3.7'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'webmock'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
end

group :staging, :production do
  gem 'logstash-event', '~> 1.2', '>= 1.2.02'
  gem 'health_check', '~> 2.7'
end
