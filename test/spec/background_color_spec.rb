# frozen_string_literal: true

require 'spec_helper'

describe 'user can change background color' do
  describe 'when source is an SVG' do
    context fixture: :minimal, action: :process
    let(:site_override) { { favicon: { 'background' => 'red' } } }

    subject do
      img_path = @context.destination 'assets/images', 'favicon-16x16.png'
      MiniMagick::Image.open img_path
    end

    it 'changes PNG background' do
      pixels = subject.get_pixels
      assert_equal [255, 0, 0], pixels[0][0]
      assert_equal [220, 20, 60], pixels[8][8]
    end
  end
end
