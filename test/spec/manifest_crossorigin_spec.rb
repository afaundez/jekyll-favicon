# frozen_string_literal: true

require 'spec_helper'
require 'nokogiri'

describe 'when site defines chrome crossorigin value' do
  context fixture: 'custom-config', action: :process

  let(:index_document) { Nokogiri::Slop File.open(index_destination) }
  let(:index_destination) { @context.destination 'index.html' }

  it 'should add crossorigin attribute to link tag' do
    tag_attribute = Jekyll::Favicon.config.dig 'chrome', 'crossorigin'
    tag_selector = %(link[crossorigin="#{tag_attribute}"])
    _(index_document.at_css(tag_selector)).wont_be_nil
  end
end
