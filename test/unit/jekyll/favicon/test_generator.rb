# frozen_string_literal: true

require 'unit_helper'
require 'jekyll/favicon/generator'

module Jekyll
  module Favicon
    # test favicons generator
    class TestGenerator < Minitest::Test
      def setup
        @generator = Favicon::Generator.new
        @site = MiniTest::Mock.new
      end

      def test_generator_has_generate_method
        refute_nil @generator
        assert_respond_to @generator, :generate
      end

      def test_generator_generate
        Jekyll::Favicon.stub :assets, [] do 
          assert_output { @generator.generate @site }
        end
      end

      def test_generator_adds_generable_asset_to_site_static_files
        generable_asset = MiniTest::Mock.new
        generable_asset.expect :generable?, true
        existing_static_file = Object.new
        static_files = [existing_static_file]
        @site.expect :static_files, static_files
        Jekyll::Favicon.stub :assets, [generable_asset] do 
          @generator.generate @site
        end
        assert_equal 2, static_files.size
        assert_includes static_files, existing_static_file
        assert_includes static_files, generable_asset
      end

      def test_generator_do_no_add_generable_asset_to_site_static_files
        non_generable_asset = MiniTest::Mock.new
        non_generable_asset.expect :generable?, false
        non_generable_asset.expect :warn_not_generable, false
        existing_static_file = Object.new
        static_files = [existing_static_file]
        @site.expect :static_files, static_files
        Jekyll::Favicon.stub :assets, [non_generable_asset] do
          @generator.generate @site
        end
        assert_equal 1, static_files.size
        assert_includes static_files, existing_static_file
      end
    end
  end
end
