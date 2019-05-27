---
layout: home
permalink: /
---
This is an example of a Jekyll site using [Jekyll Favicon Plugin](https://github.com/afaundez/jekyll-favicon).

# How does this work?

## First: the favicon gem

Add the Jekyll Favicon gem at your [Gemfile](https://github.com/afaundez/jekyll-favicon-example/blob/master/Gemfile) and bundle!

```ruby
gem 'jekyll-favicon', '~> 0.2.7', group: :jekyll_plugins
```

## Second: the favicon template

Put an SVG like [<img src='https://github.com/afaundez/jekyll-favicon-example/raw/master/favicon.svg?sanitize=1' alt='Favicon SVG' width='14' style='vertical-align: baseline;'>](https://github.com/afaundez/jekyll-favicon-example/blob/master/favicon.svg) at the root of your project and name it `favicon.svg`.

Jekyll Favicon will generate favicons in `assets/images` like these ones:

| favicon.ico | favicon-16x16.png | favicon-32x32.png | favicon-64x64.png |
|:--:||:--:||:--:||:--:|
| ![favicon.ico](https://afaundez.gitlab.io/jekyll-favicon-example/favicon.ico) | ![favicon-16x16.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-16x16.png) | ![favicon-32x32.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-32x32.png) | ![favicon-64x64.png](https://afaundez.gitlab.io/jekyll-favicon-example/assets/images/favicon-64x64.png) |

with a lot more of them. It will also generate a [browserconfig](https://afaundez.gitlab.io/jekyll-favicon-example/browserconfig.xml) and a [webmanifest](https://afaundez.gitlab.io/jekyll-favicon-example/manifest.webmanifest) at the site's root.

## Last: the favicon links and meta

In order to load those files, a new jekyll tag `favicon` is available. This goes in your head tag:

<!-- {% raw %} -->
```html
<head>
  <!-- your other head content goes here -->
  {% favicon %}
</head>
```
<!-- {% endraw %} -->

Jekyll Favicon will generate tags for all the new resources:

```html
<link rel='shortcut icon' href='favicon.ico'>
<link rel='icon' sizes='16x16' type='image/png' href='/jekyll-favicon-example/assets/images/favicon-16x16.png'>
<link rel='icon' sizes='32x32' type='image/png' href='/jekyll-favicon-example/assets/images/favicon-32x32.png'>
<link rel='icon' sizes='64x64' type='image/png' href='/jekyll-favicon-example/assets/images/favicon-64x64.png'>
<meta name='msapplication-config' content='/jekyll-favicon-example/browserconfig.xml'>
<link rel='manifest' href='/jekyll-favicon-example/manifest.webmanifest'>
```

Check the head tag of this page for the full list of links and metas.
