# frozen_string_literal: true

require 'test_helper'

describe 'empty site' do
  context fixture: :empty do
    it 'warns missing source' do
      expected_pattern = /Jekyll::Favicon: Missing favicon.svg/
      _(proc { @site.process }).must_output nil, expected_pattern
    end
  end

  context fixture: :empty, process: true do
    it "doesn't create favicon files" do
      favicon_path = @destination.join 'favicon.ico'
      _(File.exist?(favicon_path)).must_equal false
    end
  end
end
