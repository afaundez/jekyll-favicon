# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  module Favicon
    # test favicon tag
    class TestTag < Minitest::Test
      include Minitest::Hooks

      attr_reader :site, :tag

      def around
        @site = setup_site source: source(:minimal)
        super
        jekyll_execute { Jekyll::Commands::Clean.process @site.config }
      end

      def setup
        @tag = Tag.parse '', nil, nil, Liquid::ParseContext.new
      end

      def test_tag_has_render_method
        refute_nil @tag
        assert_respond_to @tag, :render
      end

      def test_tag_render_empty_when_site_has_zero_assets
        context = Liquid::Context.new({}, {}, site: @site)
        render = @tag.render context
        refute_nil render
        assert_instance_of String, render
        assert_empty render
      end

      def test_tag_render_with_assets
        asset = Favicon.assets(@site).find { |asset| asset.name == 'favicon.ico' }
        @site.static_files << asset
        context = Liquid::Context.new({}, {}, site: @site)
        render = @tag.render context
        refute_nil render
        assert_instance_of String, render
        refute_empty render
        tags = REXML::Document.new render
        refute_nil tags
        assert_equal 1, tags.children.size
        tag = tags.children.first
        assert_equal asset.name, tag['href']
      end
    end
  end
end
