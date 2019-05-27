# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) plugin adds:

- a generator for
  - a `favicon.ico`
  - multiple `favicon-[width]x[height].png`
  - a [webmanifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
  - a [browser configuration schema](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426%28v=vs.85%29)
- a tag to generate all the corresponding links and metadata needed in the head tag

## Prerequisites

Before using this plugin your system must have installed [ImageMagick](http://www.imagemagick.org) ~~(or [GraphicsMagick](http://www.graphicsmagick.org/))~~.

Check if it is already installed by running:

```sh
$ convert --version
Version: ImageMagick 7.0.8-46 Q16 x86_64 2019-05-19 https://imagemagick.org
Copyright: © 1999-2019 ImageMagick Studio LLC
License: https://imagemagick.org/script/license.php
Features: Cipher DPC HDRI Modules OpenMP(3.1)
Delegates (built-in): bzlib freetype heic jng jp2 jpeg lcms ltdl lzma openexr png tiff webp xml zlib
```

If you have a [problem converting SVG files](https://github.com/afaundez/jekyll-favicon/issues/9#issuecomment-473862194), you may need to install the package `librsvg2-bin`. For example, in Ubuntu/Debian systems:

```sh
sudo apt install librsvg2-bin
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-favicon', '~> 0.2.6', group: :jekyll_plugins
```

## Usage

If you are going to use this plugin in a hosted build/service, be sure that they include your plugins as part of the process. You can check [running example](https://afaundez.gitlab.io/jekyll-favicon-example/) hosted by [GitLab](https://about.gitlab.com/features/pages/).

As [Github Pages](https://pages.github.com) build doesn't load custom plugins, this plugin won't work. As an alternative, you can build your site and push all files (for example, build to `docs`, version it and push it, although this works only for project pages).

### Generator

By installing the plugin, it will be automatically active. It will search for the file `/favicon.svg` and generate set of files in `/assets/images` and few more items at the site's root. It also will exclude the original sources from being copied as a regular static file.

You can override these settings in your sites's `_config.yml`:

```yaml
favicon:
  source: custom-favicon-png-or.svg
  path: /assets/img
```

This plugin works best if you use an SVG with a square viewbox as the source, but you can also use a PNG instead (at least 558x588). Check [favicon.svg](/test/fixtures/sites/minimal/favicon.svg) as an example.

### Favicon tag

To get the links and meta, just add the favicon tag `{{ favicon }}`. For example, on your `index.html`

```html
---
---
<!DOCTYPE html>
<html>
  <head>
    {% favicon %}
  </head>
  <body>
    <h1>Jekyll Favicon</h1>
  </body>
</html>
```

## Development

If you want to add something, just make a PR. There is a lot to do:

- Define and check SVG/PNG attributes before execute
- Review SVG to PNG conversion, it working as it is, but some parameters are hard coded and may only work with the samples
- Encapsulate image conversion
- Tests everywhere

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afaundez/jekyll-favicon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll Favicon project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/afaundez/jekyll-favicon/blob/master/CODE_OF_CONDUCT.md).

## Acknowledgments

Notoriously inspired by [jekyll/jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) and [jekyll/jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap).
