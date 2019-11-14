$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'minitest/autorun'
require 'minitest/hooks/default'

require 'jekyll-favicon'
require 'jekyll'

Jekyll.logger.log_level = :error

def fixture(*subdirs)
  File.expand_path File.join('..', 'test', 'fixtures', *subdirs), __dir__
end
