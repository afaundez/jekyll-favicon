# frozen_string_literal: true

require "yaml"
require "spec_helper"

describe "user favicon config overrides favicon defaults" do
  fixture :configured
  subject { Jekyll::Favicon::Configuration.merged @context.site }
  let(:user_config_path) { @context.source "_config.yml" }
  let(:user_config) { YAML.load_file(user_config_path)["favicon"] }

  it "overwrites global assets attribute" do
    subject_assets = subject["assets"]
    _(subject_assets).wont_be_nil
    asset_name = "assets/configured-favicon-128x128.png"
    subject_asset = subject_assets.find { |asset| asset["name"] == asset_name }
    _(subject_asset).wont_be_nil
    _(subject_asset["source"]).must_equal "images/custom-source.svg"
  end

  it "overwrites global background attribute" do
    subject_background = subject["background"]
    _(subject_background).wont_be_nil
    _(subject_background).must_equal user_config["background"]
  end

  it "overwrites global dir attribute" do
    subject_dir = subject["dir"]
    _(subject_dir).wont_be_nil
    _(subject_dir).must_equal user_config["dir"]
  end

  it "overwrites global source attribute" do
    subject_source = subject["source"]
    _(subject_source).wont_be_nil
    _(subject_source).must_equal "name" => "custom-source.svg",
      "dir" => "images"
  end
end
