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

      def test_utils_has_merge
        assert_respond_to Favicon::Utils, :merge
      end

      def test_utils_merges_nothing_with_no_arguments
        assert_nil Favicon::Utils.merge
      end

      def test_utils_merges_nothing_with_one_argument
        assert_equal Hash[a: :b], Favicon::Utils.merge({ a: :b })
        assert_equal %i[a b], Favicon::Utils.merge(%i[a b])
        assert_equal 'a', Favicon::Utils.merge('a')
        assert_nil Favicon::Utils.merge(nil)
      end

      def test_utils_merges_nothing_with_more_than_two_arguments
        assert_equal Hash[a: %i[c d]], Favicon::Utils.merge({ a: :b }, { a: [:c] }, { a: [:d] })
      end

      def test_utils_merges_deep_nested
        assert_equal Hash[a: { b: :d }], Favicon::Utils.merge({ a: { b: :c } }, { a: { b: :d } })
        assert_equal Hash[a: %i[b c]], Favicon::Utils.merge({ a: [:b] }, { a: [:c] })
        assert_equal Hash['alpha' => nil, 'background' => 'transparent', 'define' => nil, 'density' => :max, 'extent' => :auto, 'gravity' => nil, 'resize' => '196x196', 'scale' => :auto],
                     Favicon::Utils.merge({"alpha"=>nil, "background"=>:background, "define"=>nil, "density"=>:max, "extent"=>:auto, "gravity"=>nil, "resize"=>nil, "scale"=>:auto}, {"background"=>"transparent"}, {"resize"=>"196x196"})
      end

      def test_utils_merges_overwriting_when_types_do_not_match
        assert_equal :c, Favicon::Utils.merge({ a: :b }, :c)
        assert_equal [:c], Favicon::Utils.merge({ a: :b }, [:c])
        assert_equal Hash[b: :c], Favicon::Utils.merge([:a], { b: :c })
        assert_equal Hash[a: nil], Favicon::Utils.merge({ a: [:b] }, { a: nil })
        assert_equal Hash[a: :c], Favicon::Utils.merge({ a: [:b] }, { a: :c })
        assert_equal Hash[a: :d], Favicon::Utils.merge({ a: { b: :c } }, { a: :d })
      end

      def test_utils_merges_arrays_elements
        assert_equal [{ 'name' => :a, b: :c, d: :f }], Favicon::Utils.merge([{'name' => :a, b: :c, d: :e}], [{ 'name' => :a, b: :c, d: :f }])
      end
    end
  end
end
