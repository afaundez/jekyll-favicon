# frozen_string_literal: true

require 'test_helper'

describe Jekyll::Favicon do
  it 'has config paramenters' do
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
