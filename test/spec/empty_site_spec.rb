# frozen_string_literal: true

require 'spec_helper'

describe 'empty site' do
  describe 'before processing' do
    context fixture: :empty

    it 'warns missing source' do
      expected_pattern = /Jekyll::Favicon: Missing favicon.svg/
      _(proc { @context.execute :process, log_level: :warn }).must_output nil, expected_pattern
    end
  end

  describe 'after processing' do
    context fixture: :empty, action: :process

    it "doesn't create favicon files" do
      favicon_path = @context.destination 'favicon.ico'
      _(favicon_path).path_wont_exist
    end
  end
end