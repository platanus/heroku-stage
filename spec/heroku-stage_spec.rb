require "spec_helper"

describe Heroku do
  before(:each) do
    ENV.delete('HEROKU_APP_NAME')
    subject.instance_variable_set(:@_stage, nil)
  end

  it "has a version number" do
    expect(Heroku::Stage::VERSION).not_to be nil
  end

  describe 'on production' do
    before(:each) do
      allow(Rails.env).to receive(:development?).and_return(false)
    end

    it "get the correct stage" do
      allow(ENV).to receive(:fetch).with("HEROKU_APP_NAME").and_return("myapp-staging")
      expect(Heroku.stage).to eq('staging')
    end

    it "fail with a message if dyno labs are not loaded" do
      message = <<~EOF
          key not found: "HEROKU_APP_NAME"

          Remember to enable the heroku dyno metadata to add the HEROKU_APP_NAME key to the environment.
          To do that run the folowing command:

            heroku labs:enable runtime-dyno-metadata --remote production

          On the next deploy the key will be populated with the app name
      EOF

      expect { Heroku.stage }.to raise_error(KeyError).with_message(message)
    end
  end

  describe 'on development' do
    before(:each) do
      allow(Rails.env).to receive(:development?).and_return(true)
    end

    it "get the correct stage" do
      expect(Heroku.stage).to be_empty
    end
  end
end
