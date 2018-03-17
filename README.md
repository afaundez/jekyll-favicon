# Jekyll Favicon

This [Jekyll](https://jekyllrb.com) adds the tag `favicon`. Put it on your header and it will generate common favicon links. DRY!

Notoriously inspired by [jekyll/jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-favicon', '~> 0.1.2', group: :jekyll_plugins
```

## Usage

Just add the favicon tag `{{ favicon }}`. For example, on your `index.html`

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

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jekyll-favicon. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Favicon project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jekyll-favicon/blob/master/CODE_OF_CONDUCT.md).
