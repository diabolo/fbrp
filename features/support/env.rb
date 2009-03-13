# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
Cucumber::Rails.use_transactional_fixtures

require "webrat"

  Webrat.configure do |config|
    config.mode = :rails
end

require 'cucumber/rails/rspec'

# Make visible for testing
ApplicationController.send(:public, :logged_in?, :current_user, :authorized?)
