require 'heroku/stage/version'
require 'active_support'
require 'rails'

module Heroku
  class << self
    # Returns the current Heroku stage.
    #
    #   Heroku.stage # => "staging"
    #   Heroku.stage.staging? # => true
    #   Heroku.stage.production? # => false
    def stage
      @_stage ||= ActiveSupport::StringInquirer.new(heroku_pipeline_stage)
    end

    def review_app?
      !ENV['HEROKU_PARENT_APP_NAME'].nil?
    end

    private

    def heroku_pipeline_stage
      return ENV.fetch('HEROKU_APP_NAME')[/pr-(\d*)/] if review_app?

      dev_or_test = Rails.env.development? || Rails.env.test?
      dev_or_test ? '' : ENV.fetch('HEROKU_APP_NAME')[/staging|production/]
    rescue KeyError
      raise $!, enable_dyno_metadata_message($!), $!.backtrace
    end

    def enable_dyno_metadata_message(exception)
      <<-USAGE
#{exception.message}

Remember to enable the heroku dyno metadata to add the HEROKU_APP_NAME key to the environment.
To do that run the folowing command:

  heroku labs:enable runtime-dyno-metadata --remote production

On the next deploy the key will be populated with the app name
      USAGE
    end
  end
end
