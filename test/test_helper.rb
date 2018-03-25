$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'jekyll-favicon'

require 'minitest/autorun'

def root(*subdirs)
  File.expand_path File.join('..', *subdirs), __dir__
end

def fixture(*subdirs)
  root 'test', 'fixtures', *subdirs
end
