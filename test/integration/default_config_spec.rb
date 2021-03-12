# frozen_string_literal: true

require 'test_helper'

describe 'favicon config' do
  subject { Jekyll::Favicon.config }

  it 'has default global background attribute' do
    background_attribute = subject['background']
    _(background_attribute).wont_be_nil
    _(background_attribute).must_be_kind_of String
  end

  it 'has default global path attribute' do
    path_attribute = subject['path']
    _(path_attribute).wont_be_nil
    _(path_attribute).must_be_kind_of String
  end

  it 'does not have default global sizes attribute' do
    sizes_attribute = subject['sizes']
    _(sizes_attribute).must_be_nil
  end

  it 'has default global source attribute' do
    source_attribute = subject['source']
    _(source_attribute).wont_be_nil
    _(source_attribute).must_be_kind_of String
  end

  describe 'targets' do
    it 'has default chrome config' do
      chrome_config = subject['chrome']
      _(chrome_config).wont_be_nil
      _(chrome_config).must_be_kind_of Hash
      _(chrome_config['sizes']).must_be_kind_of Array
      manifest_attributes = chrome_config['manifest']
      _(manifest_attributes).wont_be_nil
      _(manifest_attributes).must_be_kind_of Hash
      _(manifest_attributes['crossorigin']).must_be_kind_of FalseClass
      _(manifest_attributes['sizes']).must_be_kind_of Array
      _(manifest_attributes['source']).must_be_kind_of String
      _(manifest_attributes['target']).must_be_kind_of String
    end

    it 'has default classic config' do
      classic_config = subject['classic']
      _(classic_config).wont_be_nil
      _(classic_config).must_be_kind_of Hash
      _(classic_config['sizes']).must_be_kind_of Array
    end

    it 'has default ie config' do
      ie_config = subject['ie']
      _(ie_config).wont_be_nil
      _(ie_config).must_be_kind_of Hash
      _(ie_config['sizes']).must_be_kind_of Array
    end

    it 'has default safari config' do
      safari_config = subject['apple-touch-icon']
      _(safari_config).wont_be_nil
      _(safari_config).must_be_kind_of Hash
      _(safari_config['background']).must_be_kind_of String
      _(safari_config['sizes']).must_be_kind_of Array
    end
  end
end
