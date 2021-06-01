# frozen_string_literal: true

require 'spec_helper'
require 'rexml/document'

describe 'when site overrides source browserconfig' do
  fixture :configured, :process

  let(:subject_path) { @context.destination 'assets', 'configured-browserconfig.xml' }
  subject { REXML::Document.new File.read(subject_path) }

  it 'should exists only one browserconfig' do
    source_path = @context.destination 'data', 'source.xml'
    _(source_path).path_wont_exist
    _(subject_path).path_must_exist
  end

  it 'should merge and override attributes from existent webmanifest' do
    msapplication = subject.elements['/browserconfig/msapplication']
    _(msapplication).wont_be_nil
    configured = msapplication.elements['configured']
    _(configured).wont_be_nil
    _(configured.text).must_equal '/blog/assets/configured-favicon-128x128.png'
    notification = msapplication.elements['notification']
    _(notification).wont_be_nil
    _(notification).must_be :has_elements?
  end
end
