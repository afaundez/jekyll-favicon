# frozen_string_literal: true

require 'spec_helper'
require 'rexml/document'

describe 'when site has an existing custom configuration' do
  context fixture: 'custom-config', action: :process

  let(:subject_path) { @context.destination 'manifest.webmanifest' }
  subject { JSON.parse File.read subject_path }

  it 'should exists only one manifest' do
    source_path = File.join @context.destination 'data', 'source.json'
    _(source_path).path_wont_exist
    _(subject_path).path_must_exist
  end

  it 'should merge attributes from existent webmanifest' do
    _(subject).must_include 'icons'
    _(subject).must_include 'name'
    _(subject['name']).must_equal 'target.webmanifest'
  end
end
