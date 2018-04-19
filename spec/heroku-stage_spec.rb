require 'spec_helper'

describe Heroku do
  before(:each) do
    ENV.delete('HEROKU_APP_NAME')
    subject.instance_variable_set(:@_stage, nil)
  end

  it 'has a version number' do
    expect(Heroku::Stage::VERSION).not_to be nil
  end

  describe 'on production' do
    before(:each) do
      allow(Rails.env).to receive(:development?).and_return(false)
      allow(Rails.env).to receive(:test?).and_return(false)
    end

    it 'get the correct stage' do
      allow(ENV).to receive(:fetch).with('HEROKU_APP_NAME').and_return('myapp-staging')
      expect(Heroku.stage).to eq('staging')
    end

    describe '#review_app?' do
      it 'returns false' do
        expect(Heroku.review_app?).to be(false)
      end
    end

    it 'fail with a message if dyno labs are not loaded' do
      message = <<-USAGE
key not found: "HEROKU_APP_NAME"

Remember to enable the heroku dyno metadata to add the HEROKU_APP_NAME key to the environment.
To do that run the folowing command:

  heroku labs:enable runtime-dyno-metadata --remote production

On the next deploy the key will be populated with the app name
      USAGE

      expect { Heroku.stage }.to raise_error(KeyError).with_message(message)
    end
  end

  describe 'on development' do
    before(:each) do
      allow(Rails.env).to receive(:development?).and_return(true)
      allow(Rails.env).to receive(:test?).and_return(false)
    end

    it 'get the correct stage' do
      expect(Heroku.stage).to be_empty
    end
  end

  describe 'on test' do
    before(:each) do
      allow(Rails.env).to receive(:development?).and_return(false)
      allow(Rails.env).to receive(:test?).and_return(true)
    end

    it 'get the correct stage' do
      expect(Heroku.stage).to be_empty
    end
  end

  describe 'on review app' do
    before(:each) do
      allow(ENV).to receive(:[]).with("HEROKU_PARENT_APP_NAME").and_return("myapp-staging")
      allow(ENV).to receive(:fetch).with('HEROKU_APP_NAME').and_return('myapp-staging-pr-766')
    end

    it 'get the correct stage' do
      expect(Heroku.stage).to eq('pr-766')
    end

    describe '#review_app?' do
      it 'returns true' do
        expect(Heroku.review_app?).to be(true)
      end
    end
  end
end
