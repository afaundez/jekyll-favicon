require 'test_helper'

describe Jekyll::Favicon::Generator do
  before do
    @options = YAML.load_file fixture '_test.yml'
    @options['destination'] = Dir.mktmpdir
  end

  after do
    FileUtils.remove_entry @site.config['destination']
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

  describe 'using site with favicon' do
    before :all do
      @options['source'] = fixture 'sites', 'with-favicon'
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
end
