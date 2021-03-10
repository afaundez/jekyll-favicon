# frozen_string_literal: true

require 'test_helper'
require 'nokogiri'

describe 'minimal site' do
  context fixture: :minimal, process: true

  describe 'generates default files' do
    it 'creates an ICO file' do
      favicon_path = @destination.join 'favicon.ico'
      _(favicon_path).path_must_exist
    end

    it 'creates PNG files' do
      options = %w[classic ie chrome apple-touch-icon]
      options_sizes = options.collect { |option| defaults[option]['sizes'] }
      default_path = defaults['path'][1..-1]
      options_sizes.flatten.compact.uniq.each do |size|
        favicon_path = @destination.join default_path, "favicon-#{size}.png"
        _(favicon_path).path_must_exist
      end
    end

    it 'creates a webmanifest' do
      favicon_path = @destination.join defaults['chrome']['manifest']['target']
      _(favicon_path).path_must_exist
    end

    it 'creates a browserconfig' do
      favicon_path = @destination.join defaults['ie']['browserconfig']['target']
      _(favicon_path).path_must_exist
    end

    it 'creates SVG icon identical to the source' do
      default_path = defaults['path'][1..-1]
      favicon_path = @destination.join default_path, 'safari-pinned-tab.svg'
      _(favicon_path).path_must_exist
      favicon_document = File.read favicon_path
      source_path = File.join @site.source, 'favicon.svg'
      _(favicon_document).must_equal File.read(source_path)
    end

    it 'keeps SVG colors' do
      default_path = defaults['path'][1..-1]
      favicon_path = @destination.join default_path, 'favicon-16x16.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[8][8]).must_equal [220, 20, 60]
    end
  end

  describe 'when using the favicon tag' do
    let(:index_document) { Nokogiri::Slop File.open(index_destination) }
    let(:index_destination) { File.join @destination, 'index.html' }
    let(:baseurl) { @site.baseurl || '' }

    it 'adds an ico link' do
      tag_config = Jekyll::Favicon.config['ico']
      tag_href = File.join baseurl, tag_config['target']
      tag_selector = %(link[href="#{tag_href}"])
      assert index_document.at_css(tag_selector)
    end

    it 'adds a webmanifest link' do
      tag_config = Jekyll::Favicon.config['chrome']['manifest']
      tag_href = File.join baseurl, tag_config['target']
      tag_selector = %(link[href="#{tag_href}"])
      assert index_document.at_css(tag_selector)
    end

    it 'adds a browserconfig link' do
      tag_config = Jekyll::Favicon.config['ie']['browserconfig']
      tag_content = File.join baseurl, tag_config['target']
      tag_selector = %(meta[content="#{tag_content}"])
      assert index_document.at_css(tag_selector)
    end

    it 'add a safari pinned tag' do
      tag_config = Jekyll::Favicon.config['path']
      tag_href = File.join baseurl, tag_config, 'safari-pinned-tab.svg'
      tag_selector = %(link[rel="mask-icon"][href="#{tag_href}"])
      assert index_document.at_css(tag_selector)
    end

    it 'does not add a crossorigin attribute to link tag' do
      refute index_document.at_css('link[crossorigin]')
    end
  end
end
