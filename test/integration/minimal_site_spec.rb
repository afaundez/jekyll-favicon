# frozen_string_literal: true

require 'test_helper'
require 'nokogiri'

describe 'minimal site' do
  context fixture: :minimal, process: true

  describe 'generates default files' do
    it 'creates an ICO file' do
      favicon_path = @context.destination 'favicon.ico'
      _(favicon_path).path_must_exist
    end

    it 'creates PNG files' do
      options = %w[classic ie chrome apple-touch-icon]
      options_sizes = options.collect { |option| @context.defaults option, 'sizes' }
      default_path = @context.defaults('path')[1..-1]
      options_sizes.flatten.compact.uniq.each do |size|
        favicon_path = @context.destination default_path, "favicon-#{size}.png"
        _(favicon_path).path_must_exist
      end
    end

    it 'creates a webmanifest' do
      favicon_path = @context.destination @context.defaults 'chrome', 'manifest', 'target'
      _(favicon_path).path_must_exist
    end

    it 'creates a browserconfig' do
      favicon_path = @context.destination @context.defaults 'ie', 'browserconfig', 'target'
      _(favicon_path).path_must_exist
    end

    it 'creates SVG icon identical to the source' do
      default_path = @context.defaults('path')[1..-1]
      favicon_path = @context.destination default_path, 'safari-pinned-tab.svg'
      _(favicon_path).path_must_exist
      favicon_document = File.read favicon_path
      source_path = File.join @context.source, 'favicon.svg'
      _(favicon_document).must_equal File.read(source_path)
    end

    it 'keeps SVG colors' do
      default_path = @context.defaults('path')[1..-1]
      favicon_path = @context.destination default_path, 'favicon-16x16.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[8][8]).must_equal [220, 20, 60]
    end
  end

  describe 'when using the favicon tag' do
    let(:index_document) { Nokogiri::Slop File.open(index_destination) }
    let(:index_destination) { @context.destination 'index.html' }

    it 'adds an ico link' do
      tag_config = Jekyll::Favicon.config['ico']
      tag_href = @context.baseurl.join tag_config['target']
      tag_selector = %(link[href="#{tag_href}"])
      _(index_document.at_css(tag_selector)).wont_be_nil
    end

    it 'adds a webmanifest link' do
      tag_config = Jekyll::Favicon.config['chrome']['manifest']
      tag_href = @context.baseurl.join tag_config['target']
      tag_selector = %(link[href="#{tag_href}"])
      _(index_document.at_css(tag_selector)).wont_be_nil
    end

    it 'adds a browserconfig link' do
      tag_config = Jekyll::Favicon.config['ie']['browserconfig']
      tag_content = @context.baseurl.join tag_config['target']
      tag_selector = %(meta[content="#{tag_content}"])
      _(index_document.at_css(tag_selector)).wont_be_nil
    end

    it 'add a safari pinned tag' do
      tag_config = Jekyll::Favicon.config['path']
      tag_href = @context.baseurl.join tag_config, 'safari-pinned-tab.svg'
      tag_selector = %(link[rel="mask-icon"][href="#{tag_href}"])
      _(index_document.at_css(tag_selector)).wont_be_nil
    end

    it 'does not add a crossorigin attribute to link tag' do
      _(index_document.at_css('link[crossorigin]')).must_be_nil
    end
  end
end
