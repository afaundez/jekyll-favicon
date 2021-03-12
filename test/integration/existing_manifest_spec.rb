# frozen_string_literal: true

require 'test_helper'
require 'rexml/document'

describe 'when site overrides source  manifest' do
  context fixture: 'minimal-default-webmanifest', process: true

  subject do
    target_attribute = defaults.dig 'chrome', 'manifest', 'target'
    webmanifest_path = @destination.join target_attribute
    JSON.parse File.read(webmanifest_path)
  end

  it 'keeps values from existent webmanifest' do
    _(subject).must_include 'name'
  end

  it 'appends icons webmanifest' do
    _(subject).must_include 'icons'
  end
end
