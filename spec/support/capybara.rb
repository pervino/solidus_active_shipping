require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :requests

  chrome_options = Selenium::WebDriver::Chrome::Options.new

  Capybara.javascript_driver = :chrome_headless
  Capybara.register_driver :chrome_headless do |app|
    chrome_options.args << "--window-size=1440,900"
    chrome_options.args << "--headless"
    chrome_options.args << "--disable-gpu"

    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      options: chrome_options
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
