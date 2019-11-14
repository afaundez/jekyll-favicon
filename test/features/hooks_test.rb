require 'test_helper'

describe 'favicon hooks execution' do
  let(:site) { Jekyll::Site.new Jekyll.configuration('source' => source) }
  let(:user_config) { YAML.load_file File.join source, '_config.yml' }
  let(:source) { fixture 'sites', 'config' }

  it 'adds sources to exclude' do
    site.config['exclude'].must_include user_config['favicon']['source']
  end
end
