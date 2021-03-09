require 'test_helper'

describe Jekyll::Favicon do
  it 'should have a version number' do
    refute_nil Jekyll::Favicon::VERSION
  end

  it 'should have a config paramenter' do
    refute_empty Jekyll::Favicon.config
    refute_empty Jekyll::Favicon.config['source']
    refute_empty Jekyll::Favicon.config['path']
    refute_empty Jekyll::Favicon.config['classic']
    refute_empty Jekyll::Favicon.config['classic']['sizes']
    refute_empty Jekyll::Favicon.config['apple-touch-icon']
    refute_empty Jekyll::Favicon.config['apple-touch-icon']['background']
    refute_empty Jekyll::Favicon.config['apple-touch-icon']['sizes']
    refute_empty Jekyll::Favicon.config['ie']
    refute_empty Jekyll::Favicon.config['ie']['sizes']
    refute_empty Jekyll::Favicon.config['chrome']
    refute_empty Jekyll::Favicon.config['chrome']['sizes']
  end
end
