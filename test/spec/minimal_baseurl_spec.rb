# frozen_string_literal: true

require 'spec_helper'

describe 'minimal site with baseurl' do
  fixture :conventioned, :process, site: { 'baseurl' => '/blog' }

  subject { File.read @context.destination('index.html') }

  it 'adds a favicon.ico link' do
    element = REXML::Element.new 'link'
    element.add_attributes 'href' => '/blog/favicon.ico',
                            'rel' => 'shortcut icon',
                            'sizes' => '36x36 24x24 16x16',
                            'type' => 'image/x-icon'
    _(subject).must_include element.to_s
  end

  it 'adds a favicon.png link' do
    element = REXML::Element.new 'link'
    element.add_attributes 'href' => '/blog/favicon.png',
                            'rel' => 'icon',
                            'sizes' => '196x196',
                            'type' => 'image/png'
    _(subject).must_include element.to_s
  end

  it 'adds a safari pinned tab link' do
    element = REXML::Element.new 'link'
    element.add_attributes 'color' => 'transparent',
                            'href' => '/blog/safari-pinned-tab.svg',
                            'rel' => 'mask-icon'
    _(subject).must_include element.to_s
  end

  it 'adds a webmanifest link' do
    element = REXML::Element.new 'link'
    element.add_attributes 'href' => '/blog/manifest.webmanifest',
                            'rel' => 'manifest'
    _(subject).must_include element.to_s
  end

  it 'adds a browserconfig meta' do
    element = REXML::Element.new 'meta'
    element.add_attributes 'content' => '/blog/browserconfig.xml',
                            'name' => 'msapplication-config'
    _(subject).must_include element.to_s
  end

  it 'adds a browserconfig meta' do
    element = REXML::Element.new 'meta'
    element.add_attributes 'content' => '/blog/browserconfig.xml',
                            'name' => 'msapplication-config'
    _(subject).must_include element.to_s
  end

  it 'adds a tile color meta' do
    element = REXML::Element.new 'meta'
    element.add_attributes 'content' => 'transparent',
                            'name' => 'msapplication-TileColor'
    _(subject).must_include element.to_s
  end

  it 'adds a tile image meta' do
    element = REXML::Element.new 'meta'
    element.add_attributes 'content' => '/blog/mstile-icon-128x128.png',
                            'name' => 'msapplication-TileImage'
    _(subject).must_include element.to_s
  end
end
