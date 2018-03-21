# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) plugin adds:

- a .png, .ico, [webmanifest](https://developer.mozilla.org/en-US/docs/Web/Manifest), [browser configuration schema](https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/dn320426(v=vs.85) generator
- a `favicon` tag to generate all the corresponding links and metadata needed in the head tag

Notes: this project depends on [minimagick/minimagick](https://github.com/minimagick/minimagick/), which depends on [ImageMagick](https://imagemagick.org/) or [GraphicsMagick](http://www.graphicsmagick.org/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-favicon', '~> 0.1.2', group: :jekyll_plugins
```

## Usage

By installing the plugin, it will be automatically active. It will search for the file `favicon.png` and generate set of files in `/assets/images` (and some in the site's root). You can override those putting this on your `_config.yml`

```yaml
favicon:
  source: custom-favicon.png
  path: img
```

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

If you want to add something, just make a PR. There is a lot to do.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/afaundez/jekyll-favicon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll Favicon project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/afaundez/jekyll-favicon/blob/master/CODE_OF_CONDUCT.md).

## Acknowledgments

Notoriously inspired by [jekyll/jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) and [jekyll/jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap).
