
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/favicon/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-favicon'
  spec.version       = Jekyll::Favicon::VERSION
  spec.authors       = ['Alvaro Faundez']
  spec.email         = ['alvaro@faundez.net']

  spec.summary       = 'Jekyll plugin for favicon tag generation.'
  spec.description   = 'Jekyll-favicon is a jekyll plugin that adds the' \
                       ' tag favicon, generating html tags for favicon.'
  spec.homepage      = 'https://github.com/afaundez/jekyll-favicon'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.54.0', '>= 0.54.0'

  spec.add_runtime_dependency 'jekyll', '~> 3.0'
  spec.add_runtime_dependency 'mini_magick', '~> 4.5'
end
