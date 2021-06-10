# frozen_string_literal: true

require "spec_helper"

describe "user can change background color" do
  describe "when source is an SVG" do
    fixture :conventioned, :process, config: {
      name: "_config.yml",
      options: {
        "favicon" => {
          "background" => "green"
        }
      }
    }

    subject do
      img_path = @context.destination "favicon.png"
      MiniMagick::Image.open img_path
    end

    it "changes PNG background" do
      pixels = subject.get_pixels
      assert_equal [0, 128, 0], pixels[1][1]
      half_size = pixels.size / 2
      assert_equal [255, 0, 0], pixels[half_size][half_size]
    end
  end
end
