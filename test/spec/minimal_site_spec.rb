# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'

describe 'minimal site' do
  context fixture: :minimal, action: :process

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
    end

    it 'keeps SVG colors' do
      favicon_path = @context.destination 'favicon.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[98][98]).must_equal [220, 20, 60]
    end
  end

  # describe 'when using the favicon tag' do
  #   let(:index_document) { Nokogiri::Slop File.open(index_destination) }
  #   let(:index_destination) { @context.destination 'index.html' }

  #   it 'adds an ico link' do
  #     tag_config = Jekyll::Favicon.config['ico']
  #     tag_href = @context.baseurl.join tag_config['target']
  #     tag_selector = %(link[href="#{tag_href}"])
  #     _(index_document.at_css(tag_selector)).wont_be_nil
  #   end

  #   it 'adds a webmanifest link' do
  #     tag_config = Jekyll::Favicon.config['chrome']['manifest']
  #     tag_href = @context.baseurl.join tag_config['target']
  #     tag_selector = %(link[href="#{tag_href}"])
  #     _(index_document.at_css(tag_selector)).wont_be_nil
  #   end

  #   it 'adds a browserconfig link' do
  #     tag_config = Jekyll::Favicon.config['ie']['browserconfig']
  #     tag_content = @context.baseurl.join tag_config['target']
  #     tag_selector = %(meta[content="#{tag_content}"])
  #     _(index_document.at_css(tag_selector)).wont_be_nil
  #   end

  #   it 'add a safari pinned tag' do
  #     tag_config = Jekyll::Favicon.config['dir']
  #     tag_href = @context.baseurl.join tag_config, 'safari-pinned-tab.svg'
  #     tag_selector = %(link[rel="mask-icon"][href="#{tag_href}"])
  #     _(index_document.at_css(tag_selector)).wont_be_nil
  #   end

  #   it 'does not add a crossorigin attribute to link tag' do
  #     _(index_document.at_css('link[crossorigin]')).must_be_nil
  #   end
  # end
end
