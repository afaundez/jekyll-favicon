# frozen_string_literal: true

require 'test_helper'

describe 'empty site' do
  describe 'before processing' do
    context fixture: :empty

    it 'warns missing source' do
      expected_pattern = /Jekyll::Favicon: Missing favicon.svg/
      _(proc { @site.process }).must_output nil, expected_pattern
    end
  end

  describe 'after processing' do
    context fixture: :empty, process: true

    it "doesn't create favicon files" do
      favicon_path = @destination.join 'favicon.ico'
      _(File.exist?(favicon_path)).must_equal false
    end
  end
end
