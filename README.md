# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) plugin adds:

- a [custom generator](https://jekyllrb.com/docs/plugins/generators/) for
  - a `favicon.ico`
  - apple touch icons
  - a [webmanifest](https://developer.mozilla.org/en-US/docs/Web/Manifest) and its icons
  - a [browser configuration schema](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426%28v=vs.85%29) and its icons
- a [custom tag](https://jekyllrb.com/docs/plugins/tags/) for the links and metadata needed in the head tag

## Prerequisites

Before using this plugin your system must have installed [ImageMagick](http://www.imagemagick.org).

You can check if it's already installed by running:

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
gem 'jekyll-favicon', github: 'afaundez/jekyll-favicon', branch: '1.0.0.pre.alpha', group: :jekyll_plugins
```

## Usage

If you are running Jekyll on your own, the Gemfile line is all you need.

If you are going to use this plugin in a hosted build/service, be sure that they include your plugins as part of the process. You can check [this running example](https://afaundez.gitlab.io/jekyll-favicon-example/) hosted by [GitLab](https://about.gitlab.com/features/pages/).

If you are using [Github Pages](https://pages.github.com) this plugin won't work as they don't load external plugins. As an alternative, you can build your site and push all files generated (for example, build to `docs`, version it and push it, although this works only for project pages).

### Generator

By installing the plugin, it will be automatically activated. It will search for the file `/favicon.svg` and generate a full set of files in the root of your site, excluding the original sources from being copied as a regular static file.

You can override defaults favicon settings adding the following block mapping in your sites's `_config.yml`:

```yaml
favicon:
  attribute: new-value
```

#### favicon attributes

| Attribute | Values | Type | Default |
| - | - | - | - |
| source | Path to favicon SVG or PNG relative to site's source | string | `favicon.svg` |
| dir | Prepend path relative to site's destination | string |  |
| background | Background to use in case of transparency | string | `none` |
| assets | Asset(s) that must be generated. | array \| hash \| string | [assets](#assets-attributes) |
| assets_override | Set true if user assets should override default assets, otherwise the assets will be merged | boolean | false |

##### assets attributes

A single assets has the following attributes:

| Attribute | Values | Type |
| - | - | - |
| name | Basename of the asset created | string |
| sizes | List of sizes to convert source | array |
| source | Path to favicon SVG or PNG relative to site's source | string |
| dir | Prepend path relative to site's destination | string |

The final form of the assets is a block sequence:

```yaml
assets:
  - name: favicon-64x64.png,
    sizes:
      - 64x64
    source: favicon.svg
    dir: ''
  - name: favicon.png,
    sizes:
      - 16x16
    source: favicon.svg
    dir: ''
  - name: favicon-32x32.png,
    dir: assets/images
    sizes:
      - 32x32
    source: favicon.svg
    dir: ''
```

This config would generate the files:

```sh
/favicon-64x64.png
/favicon.png
/assets/images/favicon-32x32.png
```

There are DRY versions of the assets list:

###### assets attributes as a hash

```yaml
assets:
  favicon-64x64.png:
  favicon.png:
    sizes: 16x16
  favicon-32x32.png:
    dir: assets/images
```

- Every key will be used the name.
- If attribute `size` is not present and the name match the suffix `-WEIGHTxHEIGHT.EXTENSION`, for example  `favicon-16x32.png`, the size will be set `[ '16x32' ]`.
- If atributtes `source` and `dir` are not present, they will be set with favicon's attributes.

###### assets attributes as a string

```yaml
assets: favicon-64x64.png
```

is equivalent to

```yaml
assets:
  favicon-64x64.png:
```


This plugin works best if you use an SVG with a square viewbox as the source, but you can also use a PNG instead (at least 558x588). Check [favicon.svg](/test/fixtures/sites/minimal/favicon.svg) as an example.

### Favicon tag

To get the links and meta, just add the favicon tag `{% favicon %}`. For example, on your `index.html`

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
