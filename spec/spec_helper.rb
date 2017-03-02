# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require 'simplecov' if ENV['COVERAGE']
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'webmock/rspec'
require 'factory_girl'
require 'ffaker'
require 'database_cleaner'
require 'vcr'
require 'pry'
# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each {|f| require f}
#require 'spree/url_helpers'

# Requires factories defined in spree_core
require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'

Dir[File.join(File.dirname(__FILE__), "factories/*.rb")].each {|f| require f }

require 'rspec/active_model/mocks'

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include WebFixtures

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do
    DatabaseCleaner.strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Allow JS specs to work.
  config.use_transactional_fixtures = false

  #config.include Spree::UrlHelpers
  #config.include Devise::TestHelpers, :type => :controller

  # Upgrade to rspec 3.x
  config.infer_spec_type_from_file_location!
  config.example_status_persistence_file_path = "./spec/examples.txt"

  config.include FeatureHelper, type: :feature
end
