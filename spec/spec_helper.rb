$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "heroku/stage"
require "pry"

path = [File.dirname(__FILE__), "support", "**", "*.rb"]
Dir[File.join(path)].each { |f| require f }

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.include TestHelpers
end
