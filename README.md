# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) plugin adds:

- a generator for
  - a `favicon.ico`
  - multiple `favicon-[width]x[height].png`
  - a [webmanifest](https://developer.mozilla.org/en-US/docs/Web/Manifest)
  - a [browser configuration schema](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426%28v=vs.85%29)
- a tag to generate all the corresponding links and metadata needed in the head tag

Note: this project depends on [minimagick/minimagick](https://github.com/minimagick/minimagick/), which depends on [ImageMagick](https://imagemagick.org/) or [GraphicsMagick](http://www.graphicsmagick.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-favicon', '~> 0.1.2', group: :jekyll_plugins
```

## Usage

Note: this plugin does not work with the [github-pages](https://pages.github.com) build, but you can generate the site and push it.

### Generator

By installing the plugin, it will be automatically active. It will search for the file `/favicon.svg` and generate set of files in `/assets/images` and few more items at the site's root. It also will exclude the original sources from being copied as a regular static file.

You can override whit your sites's `_config.yml`:

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
