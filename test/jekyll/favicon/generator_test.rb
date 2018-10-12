require 'test_helper'

describe Jekyll::Favicon::Generator do
  before do
    @options = YAML.load_file fixture '_test.yml'
    @options['destination'] = Dir.mktmpdir
  end

  after do
    FileUtils.remove_entry @options['destination']
  end

  describe 'using empty site' do
    before do
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
    end
  end

  describe 'using site with default favicon' do
    before do
      @options['source'] = fixture 'sites', 'with-svg-favicon'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      @defaults = Jekyll::Favicon::DEFAULTS
    end

    it 'should generate favicons and metadata' do
      assert File.exist? File.join(@destination, 'favicon.ico')

      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      @options['favicon']['sizes'].each do |size|
        icon = File.join @destination, @defaults['path'], "favicon-#{size}.png"
        assert_includes generated_files, icon
      end

      assert File.exist? File.join(@destination, 'manifest.webmanifest')
      assert File.exist? File.join(@destination, 'browserconfig.xml')
    end
  end

  describe 'using site with PNG favicon' do
    before do
      @options['source'] = fixture 'sites', 'with-png-favicon'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @destination = @options['destination']
      @defaults = Jekyll::Favicon::DEFAULTS
    end

    it 'should generate favicons and metadata' do
      assert File.exist? File.join(@destination, 'favicon.ico')

      generated_files = Dir.glob File.join(@destination, '**', '*.png')
      @options['favicon']['sizes'].each do |size|
        icon = File.join @destination, @defaults['path'], "favicon-#{size}.png"
        assert_includes generated_files, icon
      end

      assert File.exist? File.join(@destination, 'manifest.webmanifest')
      assert File.exist? File.join(@destination, 'browserconfig.xml')
    end
  end

  describe 'using site with existing default webmanifest' do
    before :all do
      @options['source'] = fixture 'sites', 'with-default-webmanifest'
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

  describe 'using site with existing configured webmanifest' do
    before do
      @options['source'] = fixture 'sites', 'with-custom-webmanifest'
      @config = Jekyll.configuration @options
      @site = Jekyll::Site.new @config
      @site.process
      @site_manifest_config = @config['favicon']['chrome']['manifest']
      @target_manifest_path = File.join @options['destination'],
                                        @site_manifest_config['target']
    end

    it 'should exists only one manifest' do
      refute File.file? File.join @options['destination'],
                                  @site_manifest_config['source']
      assert File.file? File.join @target_manifest_path
    end

    it 'should merge attributes from existent webmanifest' do
      webmanifest = JSON.parse File.read @target_manifest_path
      assert_includes webmanifest.keys, 'icons'
      assert_includes webmanifest.keys, 'name'
      assert_equal webmanifest['name'], 'target.webmanifest'
    end
  end
end
