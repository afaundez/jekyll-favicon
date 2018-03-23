require 'test_helper'

describe Jekyll::Favicon do
  it 'should have a version number' do
    refute_nil Jekyll::Favicon::VERSION
  end

  it 'it should a a config paramenter' do
    refute_empty Jekyll::Favicon.config
    refute_empty Jekyll::Favicon.config['source']
    refute_empty Jekyll::Favicon.config['path']
    refute_empty Jekyll::Favicon.config['background']
    refute_empty Jekyll::Favicon.config['sizes']
  end
end
