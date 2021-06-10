# frozen_string_literal: true

require "unit_helper"
require "jekyll/favicon/utils"

module Jekyll
  module Favicon
    # test favicon utils
    class TestUtils < Minitest::Test
      def test_utils_has_compact
        assert_respond_to Favicon::Utils, :compact
      end

      def test_utils_compacts_nil
        expected_compacted = {a: 1}
        assert_equal expected_compacted,
          Favicon::Utils.compact({a: 1, c: nil})
        assert_equal [1], Favicon::Utils.compact([1, nil])
      end

      def test_utils_compacts_deep_nested_nil
        expected_compacted = {a: {b: {c: 3}}}
        assert_equal expected_compacted,
          Favicon::Utils.compact({a: {b: {c: 3, d: nil}}})
        expected_compacted = [:a, [:b, [3]]]
        assert_equal expected_compacted,
          Favicon::Utils.compact([:a, [:b, [3, nil]]])
      end

      def test_utils_compacts_empty_hash
        expected_compacted = {}
        assert_equal expected_compacted, Favicon::Utils.compact({})
      end

      def test_utils_compacts_empty_array
        assert_equal Array[], Favicon::Utils.compact([])
      end

      def test_utils_compacts_empty_mix
        expected_compacted = {a: 1}
        assert_equal expected_compacted,
          Favicon::Utils.compact({a: 1, c: {}, d: []})
        assert_equal [1], Favicon::Utils.compact([1, {}, []])
      end

      def test_utils_compacts_deep_nested_empty
        expected_compacted = {a: {b: {c: 3}}}
        assert_equal expected_compacted,
          Favicon::Utils.compact({a: {b: {c: 3, d: []}}})
        assert_equal [:a, [:b, [3]]],
          Favicon::Utils.compact([:a, [:b, [3, []]]])
      end

      def test_utils_does_nothing_to_no_compactable
        assert_nil Favicon::Utils.compact(nil)
        assert_equal 1, Favicon::Utils.compact(1)
        assert Favicon::Utils.compact(true)
      end

      def test_utils_has_merge
        assert_respond_to Favicon::Utils, :merge
      end

      def test_utils_merges_nothing_with_no_arguments
        assert_nil Favicon::Utils.merge
      end

      def test_utils_merges_nothing_with_one_argument
        expected_merged = {a: :b}
        assert_equal expected_merged, Favicon::Utils.merge({a: :b})
        assert_equal %i[a b], Favicon::Utils.merge(%i[a b])
        assert_equal "a", Favicon::Utils.merge("a")
        assert_nil Favicon::Utils.merge(nil)
      end

      def test_utils_merges_nothing_with_more_than_two_arguments
        expected_merged = {a: %i[c d]}
        assert_equal expected_merged,
          Favicon::Utils.merge({a: :b}, {a: [:c]}, {a: [:d]})
      end

      def test_utils_merges_deep_nested
        expected_merged = {a: {b: :d}}
        assert_equal expected_merged,
          Favicon::Utils.merge({a: {b: :c}}, {a: {b: :d}})
        expected_merged = {a: %i[b c]}
        assert_equal expected_merged,
          Favicon::Utils.merge({a: [:b]}, {a: [:c]})
      end

      def test_utils_merges_overwriting_when_types_do_not_match
        assert_equal :c, Favicon::Utils.merge({a: :b}, :c)
        assert_equal [:c], Favicon::Utils.merge({a: :b}, [:c])
        assert_equal ({b: :c}), Favicon::Utils.merge([:a], {b: :c})
      end

      def test_utils_merges_overwriting_when_nested_types_do_not_match
        assert_equal ({a: nil}), Favicon::Utils.merge({a: [:b]}, {a: nil})
        assert_equal ({a: :c}), Favicon::Utils.merge({a: [:b]}, {a: :c})
        assert_equal ({a: :d}),
          Favicon::Utils.merge({a: {b: :c}}, {a: :d})
      end

      def test_utils_merges_arrays_elements
        assert_equal [{"name" => :a, :b => :c, :d => :f}],
          Favicon::Utils.merge([{"name" => :a, :b => :c, :d => :e}], [{"name" => :a, :b => :c, :d => :f}])
      end
    end
  end
end
