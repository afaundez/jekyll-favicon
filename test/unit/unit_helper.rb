# frozen_string_literal: true

require 'test_helper'

# The UnitHelper Module provides reusable methods
module UnitHelper
  def self.expect_is_a(asset)
    asset.expect :is_a?, true, [Object]
  end

  def self.expect_taggable_and_tags(asset, tag)
    [[:taggable?, true], [:tags, tag]].each do |name, retval|
      asset.expect name, retval
    end
  end
end
