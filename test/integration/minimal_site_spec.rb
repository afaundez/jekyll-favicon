# frozen_string_literal: true

require 'test_helper'

describe 'minimal site' do
  context site: :minimal do
    it "doesn't warn missing source" do
      _(proc { @site.process }).must_be_silent
    end
  end

  context site: :minimal, process: true do
    it 'creates an ICO file' do
      favicon_path = @destination.join 'favicon.ico'
      _(favicon_path.exist?).must_equal true
    end

    it 'creates PNG files' do
      options = %w[classic ie chrome apple-touch-icon]
      options_sizes = options.collect { |option| @defaults[option]['sizes'] }
      default_path = @defaults['path'][1..-1]
      options_sizes.flatten.compact.uniq.each do |size|
        favicon_path = @destination.join default_path, "favicon-#{size}.png"
        _(favicon_path.exist?).must_equal true
      end
    end

    it 'creates SVG icon identical to the source' do
      default_path = @defaults['path'][1..-1]
      favicon_path = @destination.join default_path, 'safari-pinned-tab.svg'
      _(favicon_path.exist?).must_equal true
      favicon_document = File.read favicon_path
      source_path = File.join @site.source, 'favicon.svg'
      _(favicon_document).must_equal File.read(source_path)
    end

    it 'creates a webmanifest' do
      favicon_path = @destination.join @defaults['chrome']['manifest']['target']
      _(File.exist?(favicon_path)).must_equal true
    end

    it 'creates a browserconfig' do
      favicon_path = @destination.join @defaults['ie']['browserconfig']['target']
      _(File.exist?(favicon_path)).must_equal true
    end

    it 'keeps SVG colors' do
      default_path = @defaults['path'][1..-1]
      favicon_path = @destination.join default_path, 'favicon-16x16.png'
      favicon_image = MiniMagick::Image.open favicon_path
      favicon_pixels = favicon_image.get_pixels
      _(favicon_pixels[0][0]).must_equal [0, 0, 0]
      _(favicon_pixels[8][8]).must_equal [220, 20, 60]
    end
  end
end
