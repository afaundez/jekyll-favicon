# frozen_string_literal: true

require 'spec_helper'

describe 'favicon regeneration' do
  fixture :conventioned, :process

  subject { @context.destination.join 'favicon.png' }

  it 'will not modify files when reprocessing without changes' do
    pre_mtime = File.mtime subject
    @context.site.process
    post_mtime = File.mtime subject
    _(post_mtime).wont_be_nil
    _(post_mtime).must_equal pre_mtime
  end

  it 'will modify files when reprocessing after modifiying favicon source' do
    pre_mtime = File.mtime subject

    source_path = @context.source.join 'favicon.svg'
    source_overrides = { 'svg' => { 'circle' => { '_fill' => 'blue' } } }
    sleep 1 and File.write(source_path, build_site_favicon(source_overrides))
    @context.site.process

    post_mtime = File.mtime subject
    _(post_mtime).wont_be_nil
    _(post_mtime).wont_equal pre_mtime

    image = MiniMagick::Image.open subject
    pixels = image.get_pixels
    half_size = pixels.size / 2

    _(pixels[half_size][half_size]).must_equal [0, 0, 255]
  end
end
