require 'test_helper'
require 'nokogiri'

describe Jekyll::Favicon::Tag do
  before :all do
    @options = {
      'destination' => Dir.mktmpdir
    }
  end

  after :all do
    FileUtils.remove_entry @options['destination']
  end

  describe 'when site defines chrome crossorigin value' do
    before :all do
      @options['source'] = fixture 'sites', 'custom-config'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      index_destination = File.join(@destination, 'index.html')
      @index_document = Nokogiri::Slop File.open(index_destination)
    end

    it 'should add crossorigin attribute to link tag' do
      crossorigin_config = Jekyll::Favicon.config['chrome']['crossorigin']
      css_selector = 'link[crossorigin="' + crossorigin_config + '"]'
      assert @index_document.at_css(css_selector)
    end
  end
end
