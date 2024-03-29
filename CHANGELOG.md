# Changelog
All notable changes to Jekyll-Favicon will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2022-07-31
### Added
- Enable aliases when loading YAML
### Fixed
- Ruby 3.x kwargs compatibility 

## [1.0.0] - 2021-08-13
### Added
- gitignore Gemfile.lock
- gitignore .jekyll-cache
- Add Test github action workflow
- Regenration
### Changed
- Move supported ruby versions to 2.5
- Update nokogiri, minitest, and minitest-hooks gemspec's development dependencies
- Update mini_magick gemspec's runtime dependencies
- Update travis rvm versions
- Rename Gem Push github action workflow
### Fixed
- mime time error when starting new project
- fix SVG to PNG quality
### Removed
- Delete Gemfile.lock
- Delete .ruby-version
- Remove unsupported versions from travis config
- Remove bundler and rubocop gemspec's development dependencies
- Remove graphicmagick from travis config
- Remove travis-ci config
- Remove nokogiri gemspec development dependency

## [0.2.9] - 2021-02-10
### Added
- Optional `crossorigin` attribute for Chrome manifest

## [0.2.8] - 2019-09-11
### Changed
- Upgrade mini_magick 4.9.4 in gemspec for security fix
- Update gemspec to support Jekyll 4.0

## [0.2.7] - 2019-05-27
### Fixed
- Set default background back to none
- Restore safari-pinned-tab
### Changed
- Update README outdated stuff
- Correct typos on README

## [0.2.6] - 2019-03-23
### Added
- Readme troubleshooting for librsvg2-bin package missing
### Fixed
- ICO convert uses background config

## [0.2.5] - 2019-01-16
### Changed
- Strike GraphicsMagick at Readme because it's compatible a this moment
### Fixed
- Skip safari pinned tab when source is not a SVG

## [0.2.4] - 2018-10-05
### Fixed
- Path for favicon.ico in classic template
- Changelog dates
### Changed
- Drowngrade listen gem for ruby 2.1 compatibility

## [0.2.3] - 2018-08-17
### Added
- Changelog
- Contributing guide
- Issue and Pull Request templates
- Improve Readme usage
### Fixed
- Missing baseurl in links from `favicon` tag

## [0.2.2] - 2018-04-10
### Fixed
- Missing png template

## [0.2.1] - 2018-03-27
### Fixed
- Jekyll gem version dependency

## [0.2.0] - 2018-03-27
### Added
- Jekyll generator with ImageMagick dependency
- Configuration file options
- Rubocop (and changes suggested by it)

### Changed
- Templates structure

## [0.1.2] - 2018-03-17
### Fixed
- Fix gem version

## [0.1.1] - 2018-03-17
### Changed
- Replace heredoc for ruby >=2.1 compatibility

## [0.1.0] - 2018-01-30
### Added
- Jekyll tag `favicon`
