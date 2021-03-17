# frozen_string_literal: true

require 'unit_helper'

module Jekyll
  module Favicon
    # test favicon utils
    class TestUtils < Minitest::Test
      def test_utils_has_compact
        assert_respond_to Favicon::Utils, :compact
      end

      def test_utils_compacts_nil
        assert_equal Favicon::Utils.compact({ a: 1, c: nil }), { a: 1 }
        assert_equal Favicon::Utils.compact([1, nil]), [1]
      end

      def test_utils_compacts_deep_nested_nil
        assert_equal Favicon::Utils.compact({ a: { b: { c: 3, d: nil } } }),
                     { a: { b: { c: 3 } } }
        assert_equal Favicon::Utils.compact([:a, [:b, [3, nil]]]),
                     [:a, [:b, [3]]]
      end

      def test_utils_compacts_empty
        assert_equal Hash[], Favicon::Utils.compact({})
        assert_equal Array[], Favicon::Utils.compact([])
        assert_equal Hash[a: 1], Favicon::Utils.compact({ a: 1, c: {}, d: [] })
        assert_equal [1], Favicon::Utils.compact([1, {}, []])
      end

      def test_utils_compacts_deep_nested_empty
        assert_equal Hash[a: { b: { c: 3 } }],
                     Favicon::Utils.compact({ a: { b: { c: 3, d: [] } } })
        assert_equal [:a, [:b, [3]]],
                     Favicon::Utils.compact([:a, [:b, [3, []]]])
      end

      def test_utils_does_nothing_to_no_compactable
        assert_nil Favicon::Utils.compact(nil)
        assert_equal Favicon::Utils.compact(1), 1
        assert_equal Favicon::Utils.compact(true), true
      end

      def test_utils_has_find_all
        assert_respond_to Favicon::Utils, :find_all
      end

      def test_utils_finds_nothing_when_empty
        assert_equal [], Favicon::Utils.find_all({}, :a)
      end

      def test_utils_finds_all_when_deep_nested
        assert_equal [1, 2, 3],
                     Favicon::Utils.find_all({a: 1, b: { a: 2, c: { a: 3 } } }, :a)
      end
    end
  end
end
