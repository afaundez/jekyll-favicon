# frozen_string_literal: true

require 'test_helper'
require 'rexml/document'

describe 'when site has an existing custom configuration' do
  context fixture: 'custom-config', process: true

  let(:subject_keys) { %w[favicon chrome manifest target] }
  let(:subject_attribute) { @site.config.dig(*subject_keys) }
  let(:source_path) { File.join @site.source, subject_attribute }
  let(:subject_path) { @destination.join subject_attribute }
  subject { JSON.parse File.read subject_path }

  it 'should exists only one manifest' do
    _(source_path).path_wont_exist
    _(subject_path).path_must_exist
  end

  it 'should merge attributes from existent webmanifest' do
    _(subject).must_include 'icons'
    _(subject).must_include 'name'
    _(subject['name']).must_equal 'target.webmanifest'
  end
end
