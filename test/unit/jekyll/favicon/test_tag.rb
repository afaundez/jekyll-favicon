# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  module Favicon
    # test favicon tag
    class TestTag < Minitest::Test
      include Minitest::Hooks

      def around
        @site = setup_site
        super
        jekyll_execute { Jekyll::Commands::Clean.process @site.config }
      end

      def setup
        context = Liquid::Context.new({}, {}, site: @site)
        @tag = Tag.parse '', nil, nil, Liquid::ParseContext.new
        @rendered_tags = @tag.render context
      end

      def test_tag_has_render_method
        refute_nil @tag
        assert_respond_to @tag, :render
      end

      def test_tag_render_with_context
        refute_nil @rendered_tags
        assert_instance_of String, @rendered_tags
        refute_empty @rendered_tags
      end
    end
  end
end
