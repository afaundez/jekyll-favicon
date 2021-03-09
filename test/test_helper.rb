# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/hooks/default'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-favicon'

def root(*subdirs)
  File.expand_path File.join('..', *subdirs), __dir__
end

def fixture(*subdirs)
  root 'test', 'fixtures', *subdirs
end
