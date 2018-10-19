require 'test_helper'
require 'rexml/document'

describe Jekyll::Favicon::Generator do
  before :all do
    @options = {
      'destination' => Dir.mktmpdir
    }
  end

  after :all do
    FileUtils.remove_entry @options['destination']
  end

  describe 'when site source is empty' do
    before :all do
      @options['source'] = fixture 'sites', 'empty'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
    end

    it 'should not generate files because favicon source is missing' do
      assert_output(nil, /Jekyll::Favicon: Missing favicon.svg/) do
        Jekyll.logger.log_level = :warn
        @site.process
        Jekyll.logger.log_level = :error
      end
      refute File.exist? File.join @options['destination'], 'favicon.ico'
    end
  end

  describe 'when site uses default SVG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      @defaults = Jekyll::Favicon::DEFAULTS
    end

    it 'should create ICO favicon' do
      assert File.exist? File.join(@destination, 'favicon.ico')
    end

    it 'should create PNG favicons' do
      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      options = ['classic', 'ie', 'chrome', 'apple-touch-icon']
      sizes = options.collect { |option| option['sizes'] }.compact.uniq
      sizes.each do |size|
        icon = File.join @destination, @defaults['path'], "favicon-#{size}.png"
        assert_includes generated_files, icon
      end
    end

    it 'should create a webmanifest' do
      assert File.exist? File.join @destination,
                                   @defaults['chrome']['manifest']['target']
    end

    it 'should create a browserconfig' do
      assert File.exist? File.join @destination,
                                   @defaults['ie']['browserconfig']['target']
    end
  end

  describe 'when site uses default PNG favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-png-source'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      @defaults = Jekyll::Favicon::DEFAULTS
    end

    it 'should create ICO favicon' do
      assert File.exist? File.join(@destination, 'favicon.ico')
    end

    it 'should create PNG favicons' do
      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      options = ['classic', 'ie', 'chrome', 'apple-touch-icon']
      sizes = options.collect { |option| option['sizes'] }.compact.uniq
      sizes.each do |size|
        icon = File.join @destination, @defaults['path'], "favicon-#{size}.png"
        assert_includes generated_files, icon
      end
    end

    it 'should create a webmanifest' do
      assert File.exist? File.join @destination,
                                   @defaults['chrome']['manifest']['target']
    end

    it 'should create a browserconfig' do
      assert File.exist? File.join @destination,
                                   @defaults['ie']['browserconfig']['target']
    end
  end

  describe 'when site has an existing webmanifest at default location' do
    before :all do
      @options['source'] = fixture 'sites', 'minimal-default-webmanifest'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      @defaults = Jekyll::Favicon::DEFAULTS
      webmanifest_path = File.join @destination,
                                   @defaults['chrome']['manifest']['target']
      webmanifest_content = File.read webmanifest_path
      @webmanifest = JSON.parse webmanifest_content
    end

    it 'should keep values from existent webmanifest' do
      assert @webmanifest.keys.include?('name')
    end

    it 'should append icons webmanifest' do
      assert @webmanifest.keys.include?('icons')
    end
  end

  describe 'when site has an existing custom configuration' do
    before :all do
      @options['source'] = fixture 'sites', 'custom-config'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @custom_config = YAML.load_file File.join @options['source'],
                                                '_config.yml'
      @custom_favicon_config = @custom_config['favicon']
      @webmanifest_config = @custom_favicon_config['chrome']['manifest']
      @browserconfig_config = @custom_favicon_config['ie']['browserconfig']
    end

    it 'should exists only one manifest' do
      source_webmanifest_path = File.join @options['destination'],
                                          @webmanifest_config['source']
      refute File.file? source_webmanifest_path
      target_webmanifest_path = File.join @options['destination'],
                                          @webmanifest_config['target']
      assert File.file? File.join target_webmanifest_path
    end

    it 'should merge attributes from existent webmanifest' do
      target_webmanifest_path = File.join @options['destination'],
                                          @webmanifest_config['target']
      webmanifest = JSON.parse File.read target_webmanifest_path
      assert_includes webmanifest.keys, 'icons'
      assert_includes webmanifest.keys, 'name'
      assert_equal webmanifest['name'], 'target.webmanifest'
    end

    it 'should exists only one browserconfig' do
      source_browserconfig_path = File.join @options['destination'],
                                            @browserconfig_config['source']
      refute File.file? source_browserconfig_path
      target_browserconfig_path = File.join @options['destination'],
                                            @browserconfig_config['target']
      assert File.file? File.join target_browserconfig_path
    end

    it 'should merge and override attributes from existent webmanifest' do
      target_browserconfig_path = File.join @options['destination'],
                                            @browserconfig_config['target']
      browserconfig = REXML::Document.new File.read target_browserconfig_path
      msapplication = browserconfig.elements['/browserconfig/msapplication']
      tiles = msapplication.elements['tile']
      assert_equal 1, tiles.get_elements('square70x70logo').size
      assert_equal 1, tiles.get_elements('TileColor').size
      assert_equal '/assets/images/favicon-128x128.png',
                   tiles.elements['square70x70logo'].attributes['src']
      assert msapplication.elements['notification'].has_elements?
    end
  end
end
