require 'test_helper'
require 'nokogiri'

describe Jekyll::Favicon::Tag do
  before do
    @options = YAML.load_file fixture '_test.yml'
    @options['destination'] = Dir.mktmpdir
  end

  after do
    FileUtils.remove_entry @site.config['destination']
  end

  describe 'using minimal configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
    end

    it 'should generate links and meta' do
      index_destination = File.join(@destination, 'index.html')
      ico_destination = File.join @destination,
                                  Jekyll::Favicon.config['ico']['path'],
                                  'favicon.ico'
      assert File.exist? index_destination
      assert File.exist? ico_destination
      index_document = Nokogiri::Slop File.open(index_destination)
      refute_empty index_document.css('link')
      favicon_path = File.join @site.baseurl, Jekyll::Favicon.config['ico']['path'],
                               'favicon.ico'
      css_selector = 'link[href="' + favicon_path + '"]'
      assert index_document.at_css(css_selector)
    end
  end
end
