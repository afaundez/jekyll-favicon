# frozen_string_literal: true

require 'spec_helper'

describe 'minimal site with custom PNG source' do
  context fixture: 'minimal-png-source', action: :process
  let(:site_override) { { favicon: { 'source' => 'favicon.png' } } }

  describe 'generates default files' do
    it 'creates an ICO file for legacy browsers' do
      favicon_path = @context.destination 'favicon.ico'
      _(favicon_path).path_must_exist
    end

    it 'creates a PNG file for HTML 5 standard' do
      favicon_path = @context.destination 'favicon.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 196, image[:width]
      assert_equal 196, image[:height]
    end

    it 'creates a PNG file for apple touch' do
      favicon_path = @context.destination 'apple-touch-icon.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 180, image[:width]
      assert_equal 180, image[:height]
    end

    it 'creates an SVG file for safari pinned tab' do
      favicon_path = @context.destination 'safari-pinned-tab.svg'
      _(favicon_path).path_wont_exist
    end

    it 'creates a medium PNG file for webmanifest' do
      favicon_path = @context.destination 'android-chrome-192x192.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 192, image[:width]
      assert_equal 192, image[:height]
    end

    it 'creates a large PNG file for webmanifest' do
      favicon_path = @context.destination 'android-chrome-512x512.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 512, image[:width]
      assert_equal 512, image[:height]
    end

    it 'creates a small PNG files for browserconfig' do
      favicon_path = @context.destination 'mstile-icon-128x128.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 128, image[:width]
      assert_equal 128, image[:height]
    end

    it 'creates a medium PNG files for browserconfig-tiles' do
      favicon_path = @context.destination 'mstile-icon-270x270.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 270, image[:width]
      assert_equal 270, image[:height]
    end

    it 'creates a wide PNG files for browserconfig' do
      favicon_path = @context.destination 'mstile-icon-558x270.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 558, image[:width]
      assert_equal 270, image[:height]
    end

    it 'creates a large PNG files for browserconfig' do
      favicon_path = @context.destination 'mstile-icon-558x558.png'
      _(favicon_path).path_must_exist
      image = MiniMagick::Image.open favicon_path
      assert_equal 558, image[:width]
      assert_equal 558, image[:height]
    end

    it 'creates a webmanifest' do
      data_path = @context.destination 'manifest.webmanifest'
      _(data_path).path_must_exist
      data = JSON.parse File.read(data_path)
      _(data).wont_be_nil
      _(data).must_include 'icons'
      icons = data['icons']
      _(icons).must_be_kind_of Array
      icon = icons.find { |value| value['src'] == '/android-chrome-192x192.png' }
      _(icon).wont_be_nil
      icon = icons.find { |value| value['src'] == '/android-chrome-512x512.png' }
      _(icon).wont_be_nil
    end

    it 'creates a browserconfig' do
      data_path = @context.destination 'browserconfig.xml'
      _(data_path).path_must_exist
      data = REXML::Document.new File.read(data_path)
      _(data).wont_be_nil
      tiles = data.get_elements('/browserconfig/msapplication/tile')
      _(tiles).wont_be_empty
      _(tiles.size).must_equal 1
      tile = tiles.first
      _(tile).wont_be_nil
    end

    it 'keeps PNG colors' do
      favicon_path = @context.destination 'favicon.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[98][98]).must_equal [0, 0, 0]
    end
  end
end
