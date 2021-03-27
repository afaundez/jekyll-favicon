# frozen_string_literal: true

require 'unit_helper'
require 'jekyll/favicon/static_file'

module Jekyll
  module Favicon
    # test favicon tag
    class TestStaticFile < Minitest::Test
      def setup
        @site = MiniTest::Mock.new
        @site.expect :source, '/dev/null'
      end

      def test_raises_error_when_initializing_without_parameters
        assert_raises { Favicon::StaticFile.new }
      end

      def test_raises_error_when_initializing_with_nil_site
        assert_raises { Favicon::StaticFile.new nil }
      end

      def test_raises_error_when_initializing_with_empty_config
        assert_raises { Favicon::StaticFile.new @site, {} }
      end

      def test_raises_error_when_initializing_without_name_config
        assert_raises { Favicon::StaticFile.new @site, 'dir' => 'some-dir' }
      end

      def test_initializes_without_dir_config
        static_file = Favicon::StaticFile.new @site, 'name' => 'some-name'
        assert static_file
      end
    end
  end
end
