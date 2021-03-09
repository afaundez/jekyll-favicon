# frozen_string_literal: true

require 'test_helper'

module Jekyll
  module Favicon
    class TestGenerator < Minitest::Test
      def setup
        @site = Jekyll::Site.new Jekyll.configuration
        @generator = Jekyll::Favicon::Generator.new
      end

      def test_generator_has_generate_method
        refute_nil @generator
        assert_respond_to @generator, :generate
      end

      def test_generator_generate
        assert_output { @generator.generate @site }
        assert_equal @site, @generator.instance_variable_get(:@site)
      end
    end
  end
end
