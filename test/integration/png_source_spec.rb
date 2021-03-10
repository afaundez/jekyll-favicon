# frozen_string_literal: true

require 'test_helper'
require 'nokogiri'

describe 'minimal site with custom PNG source' do
  context fixture: 'minimal-png-source', process: true
  let(:site_overrides) { { favicon: { 'source' => 'favicon.png' } } }

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

    it 'does not create a SVG icon' do
      default_path = defaults['path'][1..-1]
      favicon_path = @destination.join default_path, 'safari-pinned-tab.svg'
      _(favicon_path).path_wont_exist
    end
  end

  describe 'when using the favicon tag' do
    let(:index_document) { Nokogiri::Slop File.open(index_path) }
    let(:index_path) { File.join @destination, 'index.html' }
    let(:baseurl) { @site.baseurl || '' }

    it 'does not a create safari pinned tag' do
      tag_config = Jekyll::Favicon.config['path']
      tag_href = File.join baseurl, tag_config, 'safari-pinned-tab.svg'
      tag_selector = %(link[rel="mask-icon"][href="#{tag_href}"])
      _(index_document.at_css(tag_selector)).must_be_nil
    end
  end
end
