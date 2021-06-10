# frozen_string_literal: true

require "unit_helper"
require "jekyll/favicon/static_file"

module Jekyll
  module Favicon
    # test favicon tag
    class TestStaticFile < Minitest::Test
      def setup
        setup_site
        frontmatter_defaults = Minitest::Mock.new
        3.times do
          frontmatter_defaults.expect :all, {}, [Object, Object]
          @site.expect :frontmatter_defaults, frontmatter_defaults
        end
      end

      def test_raises_error_when_initializing_without_parameters
        assert_raises(StandardError) { StaticFile.new }
      end

      def test_raises_error_when_initializing_with_nil_site
        assert_raises(StandardError) { StaticFile.new nil }
      end

      def test_raises_error_when_initializing_with_empty_config
        assert_raises(StandardError) { StaticFile.new @site, {} }
      end

      def test_raises_error_when_initializing_without_name_config
        assert_raises(StandardError) { StaticFile.new @site, "dir" => "some-dir" }
      end

      def test_initializes_without_dir_config
        static_file = StaticFile.new @site, "name" => "some-name"
        assert static_file
      end

      private

      def setup_site
        @site = MiniTest::Mock.new
        @site.expect :source, "/dev/null"
      end
    end
  end
end
