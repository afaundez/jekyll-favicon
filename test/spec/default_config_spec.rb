# frozen_string_literal: true

require 'spec_helper'

describe 'favicon config' do
  fixture :empty, :process
  subject { Jekyll::Favicon::Configuration.merged @context.site }

  it 'is the default config' do
    _(subject).must_equal Jekyll::Favicon.defaults
  end

  it 'has default global background attribute' do
    background_attribute = subject['background']
    _(background_attribute).wont_be_nil
    _(background_attribute).must_be_kind_of String
  end

  it 'has default global dir attribute' do
    path_attribute = subject['dir']
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
    _(source_attribute).must_be_kind_of Hash
    _(source_attribute['name']).wont_be_nil
    _(source_attribute['dir']).wont_be_nil
  end

  # describe 'targets' do
  #   it 'has default chrome config' do
  #     chrome_config = subject['chrome']
  #     _(chrome_config).wont_be_nil
  #     _(chrome_config).must_be_kind_of Hash
  #     _(chrome_config['sizes']).must_be_kind_of Array
  #     manifest_attributes = chrome_config['manifest']
  #     _(manifest_attributes).wont_be_nil
  #     _(manifest_attributes).must_be_kind_of Hash
  #     _(manifest_attributes['crossorigin']).must_be_kind_of FalseClass
  #     _(manifest_attributes['sizes']).must_be_kind_of Array
  #     _(manifest_attributes['source']).must_be_kind_of String
  #     _(manifest_attributes['target']).must_be_kind_of String
  #   end

  #   it 'has default classic config' do
  #     classic_config = subject['classic']
  #     _(classic_config).wont_be_nil
  #     _(classic_config).must_be_kind_of Hash
  #     _(classic_config['sizes']).must_be_kind_of Array
  #   end

  #   it 'has default ie config' do
  #     ie_config = subject['ie']
  #     _(ie_config).wont_be_nil
  #     _(ie_config).must_be_kind_of Hash
  #     _(ie_config['sizes']).must_be_kind_of Array
  #     _(ie_config['tile-color']).must_be_kind_of String
  #     browserconfig_attributes = ie_config['browserconfig']
  #     _(browserconfig_attributes).wont_be_nil
  #     _(browserconfig_attributes).must_be_kind_of Hash
  #     _(browserconfig_attributes['source']).must_be_kind_of String
  #     _(browserconfig_attributes['target']).must_be_kind_of String
  #   end

  #   it 'has default safari config' do
  #     safari_config = subject['apple-touch-icon']
  #     _(safari_config).wont_be_nil
  #     _(safari_config).must_be_kind_of Hash
  #     _(safari_config['background']).must_be_kind_of String
  #     _(safari_config['sizes']).must_be_kind_of Array
  #   end

  #   it 'has default safari-pinned-tab config' do
  #     safari_config = subject['safari-pinned-tab']
  #     _(safari_config).wont_be_nil
  #     _(safari_config).must_be_kind_of Hash
  #     _(safari_config['mask-icon-color']).must_be_kind_of String
  #   end

  #   it 'has default SVG config' do
  #     svg_config = subject['svg']
  #     _(svg_config).wont_be_nil
  #     _(svg_config).must_be_kind_of Hash
  #     _(svg_config['density']).must_be_kind_of Integer
  #     _(svg_config['dimensions']).must_be_kind_of String
  #   end

  #   it 'has default PNG config' do
  #     png_config = subject['png']
  #     _(png_config).wont_be_nil
  #     _(png_config).must_be_kind_of Hash
  #     _(png_config['dimensions']).must_be_kind_of String
  #   end

  #   it 'has default ICO config' do
  #     ico_config = subject['ico']
  #     _(ico_config).wont_be_nil
  #     _(ico_config).must_be_kind_of Hash
  #     _(ico_config['target']).must_be_kind_of String
  #     _(ico_config['sizes']).must_be_kind_of Array
  #   end
  # end
end
