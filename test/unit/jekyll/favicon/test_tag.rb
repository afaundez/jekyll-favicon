# frozen_string_literal: true

require 'test_helper'

module Jekyll
  module Favicon
    class TestTag < Minitest::Test
      def setup
        site = Jekyll::Site.new Jekyll.configuration
        context = Liquid::Context.new({}, {}, site: site)
        @tag = Jekyll::Favicon::Tag.parse '', nil, nil, Liquid::ParseContext.new
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
