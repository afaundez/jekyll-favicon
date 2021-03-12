# frozen_string_literal: true

require 'test_helper'
require 'rexml/document'

describe 'when site overrides source browserconfig' do
  context fixture: 'custom-config', process: true

  let(:subject_keys) { %w[favicon ie browserconfig target] }
  let(:subject_attribute) { @site.config.dig(*subject_keys) }
  let(:source_path) { File.join @site.source, subject_attribute }
  let(:subject_path) { @destination.join subject_attribute }
  subject { REXML::Document.new File.read(subject_path) }

  it 'should exists only one browserconfig' do
    _(source_path).path_wont_exist
    _(subject_path).path_must_exist
  end

  it 'should merge and override attributes from existent webmanifest' do
    msapplication = subject.elements['/browserconfig/msapplication']
    _(msapplication).wont_be_nil
    tile = msapplication.elements['tile']
    _(tile).wont_be_nil
    tile_logo = tile.elements['square70x70logo']
    _(tile_logo).wont_be_nil
    _(tile_logo.attributes['src']).must_equal '/assets/images/favicon-128x128.png'
    tile_color = tile.get_elements('TileColor')
    _(tile_color).wont_be_nil
    _(msapplication.elements['notification']).must_be :has_elements?
  end
end
