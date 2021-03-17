# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  module Favicon
    # test favicons generator
    class TestGenerator < Minitest::Test
      include Minitest::Hooks

      def around
        @site = setup_site
        super
        jekyll_execute { Jekyll::Commands::Clean.process @site.config }
      end

      def setup
        @generator = Generator.new
      end

      def test_generator_has_generate_method
        refute_nil @generator
        assert_respond_to @generator, :generate
      end

      def test_generator_generate
        assert_output { @generator.generate @site }
      end
    end
  end
end
