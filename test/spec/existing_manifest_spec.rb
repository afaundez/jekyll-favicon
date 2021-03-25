# frozen_string_literal: true

require 'spec_helper'
require 'rexml/document'

describe 'when site overrides source  manifest' do
  context fixture: 'minimal-default-webmanifest', action: :process

  subject do
    webmanifest_path = @context.destination 'manifest.webmanifest'
    JSON.parse File.read(webmanifest_path)
  end

  it 'keeps values from existent webmanifest' do
    _(subject).must_include 'name'
  end

  it 'appends icons webmanifest' do
    _(subject).must_include 'icons'
  end
end
