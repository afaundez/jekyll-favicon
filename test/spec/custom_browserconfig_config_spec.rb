# frozen_string_literal: true

require 'spec_helper'
require 'rexml/document'

describe 'when site overrides source browserconfig' do
  context fixture: 'custom-config', action: :process

  let(:subject_path) { @context.destination 'browserconfig.xml' }
  subject { REXML::Document.new File.read(subject_path) }

  it 'should exists only one browserconfig' do
    source_path = @context.destination 'data', 'source.xml'
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
    _(tile_logo.attributes['src']).must_equal '/mstile-icon-128x128.png'
    tile_color = tile.get_elements('TileColor')
    _(tile_color).wont_be_nil
    notification = msapplication.elements['notification']
    _(notification).wont_be_nil
    _(notification).must_be :has_elements?
  end
end
