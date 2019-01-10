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

  describe 'using minimal configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      index_destination = File.join(@destination, 'index.html')
      @index_document = Nokogiri::Slop File.open(index_destination)
      @site_baseurl = @site.baseurl || ''
    end

    it 'should generate ico link' do
      ico_config = Jekyll::Favicon.config['ico']
      ico_path = File.join @site_baseurl, ico_config['target']
      css_selector = 'link[href="' + ico_path + '"]'
      assert @index_document.at_css(css_selector)
    end

    it 'should generate webmanifest link' do
      webmanifest_config = Jekyll::Favicon.config['chrome']['manifest']
      webmanifest_path = File.join File.join @site_baseurl,
                                             webmanifest_config['target']
      css_selector = 'link[href="' + webmanifest_path + '"]'
      assert @index_document.at_css(css_selector)
    end

    it 'should generate browserconfig link' do
      browserconfig_config = Jekyll::Favicon.config['ie']['browserconfig']
      browserconfig_path = File.join File.join @site_baseurl,
                                               browserconfig_config['target']
      css_selector = 'meta[content="' + browserconfig_path + '"]'
      assert @index_document.at_css(css_selector)
    end

    it 'should include safari pinned tag' do
      pinned_path = File.join @site_baseurl,
                              Jekyll::Favicon.config['path'],
                              'safari-pinned-tab.svg'
      css_selector = 'link[ rel="mask-icon"][href="' + pinned_path + '"]'
      assert @index_document.at_css(css_selector)
      assert pinned_path, @index_document.css(css_selector).attribute('href')
    end
  end

  describe 'when site uses default PNG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-png-source'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      index_destination = File.join(@destination, 'index.html')
      @index_document = Nokogiri::Slop File.open(index_destination)
      @site_baseurl = @site.baseurl || ''
    end

    it 'should skip safari pinned tag' do
      pinned_path = File.join @site_baseurl,
                              Jekyll::Favicon.config['path'],
                              'safari-pinned-tab.svg'
      css_selector = 'link[ rel="mask-icon"][href="' + pinned_path + '"]'
      refute @index_document.at_css(css_selector)
    end
  end
end
