source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'

gem 'rails', '~> 5.0.1'

# Database
gem 'pg', '~> 0.18'

# Server
gem 'puma', '~> 3.0'

# Assets
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

gem 'haml-rails', '~> 0.9'

# GOV.UK UI
gem 'govuk_template'
gem 'govuk_frontend_toolkit'
gem 'govuk_elements_rails'
gem 'govuk_elements_form_builder', git: 'https://github.com/ministryofjustice/govuk_elements_form_builder'

# Ruby client for OpenRegisters
gem 'openregister-ruby', git: 'https://github.com/openregister/openregister-ruby-client'

# Email and Text Notifications
gem 'govuk_notify_rails'

# Deploying jobs
gem 'sidekiq'

# User authentication
gem 'devise'
gem 'devise_invitable'
gem 'cancancan'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'letter_opener'
end
