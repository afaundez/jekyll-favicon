require 'test_helper'

describe 'Setup Favicon configuration configuration with hooks' do
  before do
    @options = {}
    @options['quiet'] = true
    @options['source'] = fixture 'sites', 'fake'
    @options['destination'] = Dir.mktmpdir
    @config = Jekyll.configuration @options
    @site = Jekyll::Site.new @config
  end

  after do
    FileUtils.remove_entry @site.config['destination']
  end

  it 'should loads favicon config in default config file' do
    custom = YAML.load_file(File.join(@options['source'], '_config.yml'))['favicon']
    assert @site.config['favicon']['source'], custom['source']
    assert @site.config['favicon']['path'], custom['path']
    assert @site.config['favicon']['background'], custom['background']
    assert @site.config['favicon']['sizes'].size == 1
    assert_includes @site.config['favicon']['sizes'], custom['sizes'].first
    assert_includes @site.config['exclude'], custom['source']
  end
end
