require 'test_helper'

describe 'Setup Favicon configuration configuration with hooks' do
  before do
    @options = { 'source' => fixture('sites', 'config') }
    @site = Jekyll::Site.new Jekyll.configuration @options
    config_raw = File.join @options['source'], '_config.yml'
    @custom = YAML.load_file(config_raw)['favicon']
    @favicon_site_config = @site.config['favicon']
  end

  it 'should loads favicon config in default config file' do
    assert @favicon_site_config['source'], @custom['source']
    assert @favicon_site_config['path'], @custom['path']
    assert @favicon_site_config['background'], @custom['background']
    assert @favicon_site_config['sizes'].size == 1
    assert_includes @favicon_site_config['sizes'], @custom['sizes'].first
    assert_includes @site.config['exclude'], @custom['source']
  end
end
