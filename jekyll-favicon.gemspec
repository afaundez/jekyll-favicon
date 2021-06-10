# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll/favicon/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-favicon"
  spec.version = Jekyll::Favicon::VERSION
  spec.authors = ["Alvaro Faundez"]
  spec.email = ["alvaro@faundez.net"]

  spec.summary = "Jekyll plugin for favicon tag generation."
  spec.description = "Jekyll-favicon is a jekyll plugin that adds the" \
                       " tag favicon, generating html tags for favicon."
  spec.homepage = "https://github.com/afaundez/jekyll-favicon"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-hooks", "~> 1.5"
  spec.add_development_dependency "minitest-reporters", "~> 1.4.3"
  spec.add_development_dependency "rake", "~> 12.3"

  spec.add_runtime_dependency "jekyll", ">= 3.0", "< 5.0"
  spec.add_runtime_dependency "mini_magick", "~> 4.11"
  spec.add_runtime_dependency "rexml", "~> 3.2", ">= 3.2.5"
end
