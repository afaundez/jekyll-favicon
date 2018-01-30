require 'test_helper'

class Jekyll::FaviconTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jekyll::Favicon::VERSION
  end
end
