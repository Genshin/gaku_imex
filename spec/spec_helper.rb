require 'rubygems'
require 'sidekiq'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'active_record/fixtures'
require 'factory_girl_rails'
require 'sidekiq/testing'
require 'handy_controller_helpers'
require 'paperclip/matchers'
require 'ffaker'

require 'gaku/testing/env'
require 'gaku/testing/factories'
require 'gaku/testing/controller_helpers'
require 'gaku/testing/feature_helpers'
require 'gaku/testing/flash_helpers'
require 'gaku/testing/auth_helpers'
require 'gaku/core/url_helpers'

if defined?(Coveralls)
  require 'coveralls'
  Coveralls.wear!
end

if defined?(Simplecov)
  # Run Coverage report
  require 'simplecov'
  puts 'Starting SimpleCov'
  SimpleCov.start do
    add_filter '/support/'
    add_filter '/support/features/'
    add_filter '/spec/features/**'
    add_filter '/config/**'
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Workers', 'app/workers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Libraries', 'lib'
  end
end


Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do
    if example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.deprecation_stream = 'log/deprecations.log'
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  config.include Devise::TestHelpers, type: :controller
  config.include Gaku::Core::UrlHelpers
  config.include HandyControllerHelpers::AllHelpers, type: :controller
end