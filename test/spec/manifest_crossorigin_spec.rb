# frozen_string_literal: true

require 'spec_helper'

describe 'when site defines chrome crossorigin value' do
  fixture :configured, :process, site: {
    'favicon' => {
      'assets' => [{
          'name' => 'assets/manifest.webmanifest',
          'source' => 'data/source.json',
          'tag' => [{ 'link' => { 'href' => :href, 'crossorigin' => 'use-credentials' } }]
    }]}
  }

  subject { REXML::Document.new File.open(index_destination) }
  let(:index_destination) { @context.destination 'index.html' }

  it 'should add crossorigin attribute to link tag' do
    link = subject.elements['/html/head/link']
    _(link).wont_be_nil
    _(link.attributes['href']).must_equal '/blog/assets/configured-favicon-128x128.png'
    _(link.attributes['crossorigin']).must_equal 'use-credentials'
  end
end
