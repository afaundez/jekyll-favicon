# frozen_string_literal: true

require 'spec_helper'

describe 'minimal site' do
  fixture :conventioned, :process

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
      _(favicon_path).path_must_exist
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

    it 'keeps SVG colors' do
      favicon_path = @context.destination 'favicon.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[98][98]).must_equal [255, 0, 0]
    end
  end

  describe 'when using the favicon tag' do
    subject { File.read @context.destination('index.html') }

    it 'adds a favicon.ico link' do
      element = REXML::Element.new 'link'
      element.add_attributes 'href' => '/favicon.ico',
                             'rel' => 'shortcut icon',
                             'sizes' => '36x36 24x24 16x16',
                             'type' => 'image/x-icon'
      _(subject).must_include element.to_s
    end

    it 'adds a favicon.png link' do
      element = REXML::Element.new 'link'
      element.add_attributes 'href' => '/favicon.png',
                             'rel' => 'icon',
                             'sizes' => '196x196',
                             'type' => 'image/png'
      _(subject).must_include element.to_s
    end

    it 'adds a safari pinned tab link' do
      element = REXML::Element.new 'link'
      element.add_attributes 'color' => 'transparent',
                             'href' => '/safari-pinned-tab.svg',
                             'rel' => 'mask-icon'
      _(subject).must_include element.to_s
    end

    it 'adds a webmanifest link' do
      element = REXML::Element.new 'link'
      element.add_attributes 'href' => '/manifest.webmanifest',
                              'rel' => 'manifest'
      _(subject).must_include element.to_s
    end

    it 'adds a browserconfig meta' do
      element = REXML::Element.new 'meta'
      element.add_attributes 'content' => '/browserconfig.xml',
                             'name' => 'msapplication-config'
      _(subject).must_include element.to_s
    end

    it 'adds a browserconfig meta' do
      element = REXML::Element.new 'meta'
      element.add_attributes 'content' => '/browserconfig.xml',
                             'name' => 'msapplication-config'
      _(subject).must_include element.to_s
    end

    it 'adds a tile color meta' do
      element = REXML::Element.new 'meta'
      element.add_attributes 'content' => 'transparent',
                             'name' => 'msapplication-TileColor'
      _(subject).must_include element.to_s
    end

    it 'adds a tile image meta' do
      element = REXML::Element.new 'meta'
      element.add_attributes 'content' => '/mstile-icon-128x128.png',
                             'name' => 'msapplication-TileImage'
      _(subject).must_include element.to_s
    end
  end
end
