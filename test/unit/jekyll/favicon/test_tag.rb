# frozen_string_literal: true

require 'unit_helper'
require 'jekyll/favicon/tag'

module Jekyll
  module Favicon
    # test favicon tag
    class TestTag < Minitest::Test
      def setup
        liquid_parse_context = MiniTest::Mock.new
        liquid_parse_context.expect :line_number, 1
        @tag = Favicon::Tag.parse '', nil, nil, liquid_parse_context
        @site = MiniTest::Mock.new
        @context= MiniTest::Mock.new
        @context.expect :registers, site: @site
        non_asset = MiniTest::Mock.new
        non_asset.expect :is_a?, false, [Object]
        @static_files = [non_asset]
      end

      def test_tag_has_render_method
        refute_nil @tag
        assert_respond_to @tag, :render
      end

      def test_tag_render_empty_when_site_has_zero_assets
        %w[<tag1/> <tag2/>].each do |tag|
          taggable_asset = MiniTest::Mock.new
          taggable_asset.expect :is_a?, true, [Object]
          taggable_asset.expect :taggable?, true
          taggable_asset.expect :tags, tag
          @static_files << taggable_asset
        end
        @site.expect :static_files, @static_files
        rendered_tags = @tag.render @context
        assert_instance_of String, rendered_tags
        assert_equal "<tag1/>\n<tag2/>", rendered_tags
      end
    end
  end
end
