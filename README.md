---
layout: default
permalink: /
---
# Jekyll Favicon Example

Welcome!

This is an example of a Jekyll site using of [Jekyll Favicon Plugin](https://github.com/afaundez/jekyll-favicon).

How does this work?

## First: the gem

Add the gem at your [Gemfile](Gemfile)

```ruby
gem 'jekyll-favicon', '~> 0.2.3', group: :jekyll_plugins
```

And bundle.

## Second: the favicon template

Just put a SVG (or PNG) at the root of your project and name it `favicon.svg`. Like [this](favicon.svg):

![Favicon SVG](https://github.com/afaundez/jekyll-favicon-example/raw/master/favicon.svg?sanitize=1)

With that, Jekyll will generate several favicons in `assets/images` like this one:

![favicon.ico](https://afaundez.gitlab.io/jekyll-favicon-example/favicon.ico)
![favicon-16x16.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-16x16.png)
![favicon-32x32.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-32x32.png)
![favicon-64x64.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-64x64.png)

and some other files at the root of the site.

## Third: the links and meta

In order to load those files, there is a Jekyll tag that does the work. This goes in the head tag:

<!-- {% raw %} -->
```html
<head>
  <!-- your other head content goes here -->
  {% favicon %}
</head>
```
<!-- {% endraw %} -->
