---
layout: home
permalink: /
---
This is an example of a Jekyll site using [Jekyll Favicon Plugin](https://github.com/afaundez/jekyll-favicon).

# How does this work?

## First: the favicon gem

Add the Jekyll Favicon gem at your [Gemfile](https://github.com/afaundez/jekyll-favicon/blob/gh-pages/Gemfile#L7) and bundle!

```ruby
gem 'jekyll-favicon', '~> 1.0.0.pre.3', group: :jekyll_plugins
```

## Second: the favicon template

Put an SVG like [<img src='https://github.com/afaundez/jekyll-favicon/raw/gh-pages/favicon.svg?sanitize=1' alt='Favicon SVG example' width='14' style='vertical-align: baseline;'>](https://github.com/afaundez/jekyll-favicon/blob/gh-pages/favicon.svg) at the root of your project and name it `favicon.svg`.

| favicon.ico                                        | favicon.png                                        | safari-pinned-tab.svg                                                  |
|----------------------------------------------------|----------------------------------------------------|------------------------------------------------------------------------|
| ![favicon.ico]({{ 'favicon.ico' | relative_url }}) | ![favicon.png]({{ 'favicon.png' | relative_url }}) | ![safari-pinned-tab.svg]({{ 'safari-pinned-tab.svg' | relative_url }}) |


| android-chrome-192x192.png                                                       | android-chrome-512x512.png                                                       |
|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| ![android-chrome-192x192.png]({{ 'android-chrome-192x192.png' | relative_url }}) | ![android-chrome-512x512.png]({{ 'android-chrome-512x512.png' | relative_url }}) |

| mstile-icon-128x128.png                                                    | mstile-icon-270x270.png                                                    | mstile-icon-558x270.png                                                    | mstile-icon-558x558.png                                                    |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------|----------------------------------------------------------------------------|
| ![mstile-icon-128x128.png]({{ 'mstile-icon-128x128.png' | relative_url }}) | ![mstile-icon-270x270.png]({{ 'mstile-icon-270x270.png' | relative_url }}) | ![mstile-icon-558x270.png]({{ 'mstile-icon-558x270.png' | relative_url }}) | ![mstile-icon-558x558.png]({{ 'mstile-icon-558x558.png' | relative_url }}) |

Also, It will generate or update a [browserconfig]({{ 'browserconfig.xml' | relative_url }}) and a [webmanifest]({{ 'manifest.webmanifest' | relative_url }}).

## Last: the favicon links and meta

In order to load those files, a new Liquid tag `favicon` is available. Use it in your head tag:

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
<link href='/favicon.ico' rel='shortcut icon' sizes='36x36 24x24 16x16' type='image/x-icon'/>
<link href='/favicon.png' rel='icon' sizes='196x196' type='image/png'/>
<link color='transparent' href='/safari-pinned-tab.svg' rel='mask-icon'/>
<meta content='/mstile-icon-128x128.png' name='msapplication-TileImage'/>
<meta content='transparent' name='msapplication-TileColor'/>
<link href='/manifest.webmanifest' rel='manifest'/>
<meta content='/browserconfig.xml' name='msapplication-config'/>
```

Use yout browser to inspect the source code of this page, specifically, the content of the `head` tag.
