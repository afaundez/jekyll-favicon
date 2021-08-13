# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) plugin adds:

- a generator for favicons (ICO, PNG, SVG), [webmanifests]((https://developer.mozilla.org/en-US/docs/Web/Manifest)), and [browserconfig]((https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426%28v=vs.85%29)) files
- a tag for the rendinering of all the corresponding links and metadata needed

Tested with:

- Jekyll 3.6 to 3.7, ruby 2.6 to 2.7
- Jekyll 3.8 to 4.2, ruby 2.6 to 3.0

## Prerequisites

### [ImageMagick](http://www.imagemagick.org)

Check if it is already installed by running:

```sh
$ convert --version | grep Version
Version: ImageMagick 7.0.8-46 Q16 x86_64 2019-05-19 https://imagemagick.org
```

### [librsvg](https://gitlab.gnome.org/GNOME/librsvg) (optional)

If you are having pixeled icons or if you have a [problem converting SVG files](https://github.com/afaundez/jekyll-favicon/issues/9#issuecomment-473862194), you may need to install the package `librsvg2-bin`. For example, in Ubuntu/Debian systems:

```sh
sudo apt install librsvg2-bin
```

You may need to install `librsvg` before installing the RSVG renderer.

Check the devcontainer's [Dockerfile](.devcontainer/Dockerfile) for more practical details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-favicon', '~> 1.0.0', group: :jekyll_plugins
```

## Usage

If you are going to use this plugin in a hosted build/service, be sure that they include your plugins as part of the process. You can check [gh-pages](/afaundez/jekyll-favicon/tree/gh-pages) branch for a working example.

As [Github Pages](https://pages.github.com) doesn't load custom plugins, this plugin won't be included on the build process. As a workaround, you can build your site and push all files (for example, build to `docs`, version it and push it, although this works only for project pages).


### Generator

By installing the plugin, it will be automatically activated without further configurations.

You can override these settings in your sites's `_config.yml`. The simplest configuration would be this:

```yaml
favicon:
  source: custom-favicon-png-or.svg
```

This plugin works best if you use an SVG with a square viewbox as the source, but you can also use a PNG instead (at least 558x588). Check the fixtures [favicon.svg](test/fixtures/favicon.svg) or [favicon.png](test/fixtures/favicon.png) as examples.

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
  </body>
</html>
```

## Configuration

The plugin customization goes in the `favicon` key in the `_config.yml` file. There are four key parameters:

| attribute name | type        | default                                                                                                                                                                                                                 | description                                                                                                              |
|----------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| source         | hash/string | <div class="highlight highlight-source-yaml position-relative"><pre><span class="pl-ent">name</span>: <span class="pl-s">favicon.svg</span><br><span class="pl-ent">dir</span>: <span class="pl-s">.</span></pre></div> | SVG or PNG file relative to site's source. Any favicon without explicit source will use this attribute as default.       |
| background     | string      | `transparent`                                                                                                                                                                                                           | Color keyword or Hex representation. Any favicon without explicit convert background will use this attribute as default. |
| dir            | string      | `.`                                                                                                                                                                                                                     | Path relative to site's source. Any favicon without explicit source dir will use this attribute as default.              |
| assets         | array       | see [defaults](config/jekyll/favicon.yml)                                                                                                                                                                               | Array of asset configuration. Any asset define here will be controlled with this plugin.                                 |

### Assets

The assets is an array of file spec:

| attribute name | type          | default     | description                                |
|----------------|---------------|-------------|--------------------------------------------|
| name           | string        |             | file's basename. Required.                 |
| dir            | string/symbol | `:site_dir` | file's dir, relative to site's destination |
| source         | hash          |             | file's source. Required.                   |
| convert        | hash          | `{}`        | see [convert defaults](#convert)           |
| tags           | array         | `[]`        | see [tags defaults](#tags)                 |
| refer          | hash          | `[]`        | see [refer defaults](#refer)               |

Symbol values:

- `:background`: favicon's global background
- `:site_dir`: favicon's global dir
- `:href`: favicons absolute URL path

#### Convert

The convert configuration is specific for each type of convertion: SVG to ICO/PNG/SVG and PNG to ICO/PNG.

| attribute name | type          | default                                                                 | description                                                                                           |
|----------------|---------------|-------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| alpha          | string        | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick alpha docs](https://imagemagick.org/script/command-line-options.php#alpha)           |
| background     | string/symbol | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick background docs](https://imagemagick.org/script/command-line-options.php#background) |
| define         | string/symbol | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick define docs](https://imagemagick.org/script/command-line-options.php#define)         |      |
| extent         | string/symbol | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick extent docs](https://imagemagick.org/script/command-line-options.php#extent)         |
| gravity        | string        | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick gravity docs](https://imagemagick.org/script/command-line-options.php#gravity)       |
| resize         | string        | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick resize docs](https://imagemagick.org/script/command-line-options.php#resize)         |
| size          | string        | see [convert config](config/jekyll/favicon/static_file/convertible.yml) | see [imagemagick size docs](https://imagemagick.org/script/command-line-options.php#size)           |

Symbol values:

- `:auto`: if sizes is not a square, then sizes
- `:max`: 3 times the largest dimension

#### Tags

The tags configuration is a list of hashes with only one key, `link` or `meta`, and only one value, a hash with the HTML attributes associated to the key. See [tags defaults](config/jekyll/favicon/static_file/taggable.yml) for more details.

#### Refer

The refer configuration is a list of hashes with only one key, `webmanifest` or `browserconfig`, and only one value, a hash that will override the associated file. See [refer defaults](config/jekyll/favicon/static_file/referenceable.yml) for more details.

## Development

If you want to add something, just make a PR. There is a lot to do:

- Tests more cases
- Keep updated the favicons and files needed with modern browsers

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afaundez/jekyll-favicon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll Favicon project’s codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/afaundez/jekyll-favicon/blob/master/CODE_OF_CONDUCT.md).

## Acknowledgments

Notoriously inspired by [jekyll/jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) and [jekyll/jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap).
