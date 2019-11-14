require 'test_helper'

describe Jekyll::Favicon do
  let(:site) { Jekyll::Site.new Jekyll::Configuration.from({}) }
  let(:defaults) { { 'source' => 'source.svg', 'dir' => 'pathname' } }

  describe '.create_assets' do
    it 'is a private method' do
      Jekyll::Favicon.wont_respond_to :create_assets
      Jekyll::Favicon.must_respond_to :send, :create_assets
    end

    let(:subject) do
      Jekyll::Favicon.send :create_assets, site, raw_assets, defaults
    end

    describe 'when providing an empty assets collection' do
      let(:raw_assets) {}

      it 'does not create assets' do
        subject.must_be_kind_of Array
        subject.must_be_empty
      end
    end

    describe 'when providing a hash with values nil or hashes as assets' do
      let(:raw_assets) do
        {
          'valid-1x1.png' => nil,
          'valid-2x2.png' => '',
          'valid-3x3.png' => 'non-skip-text',
          'valid-4x4.png' => {},
          'valid-5x5.png' => { 'key' => 'value' },
          'valid-6x6.png' => [],
          'skip-this.png' => 'skip'
        }
      end

      it 'provides an Jekyll::Favicon::Asset collection' \
         "if raw_asset's values are hashes or nil" do
        subject.each { |asset| asset.must_be_kind_of Jekyll::Favicon::Asset }
      end

      it 'does not create asset if value is the string `skip`' do
        subject.size.must_equal raw_assets.size - 1
        skipped_asset = subject.find { |asset| 'skip-this.png'.eql? asset.name }
        skipped_asset.must_be_nil
      end
    end
  end

  describe '.create_asset' do
    it 'is a private method' do
      Jekyll::Favicon.wont_respond_to :create_asset
      Jekyll::Favicon.must_respond_to :send, :create_asset
    end

    let(:subject) { Jekyll::Favicon.send :create_asset, site, attributes }
    let(:attributes) { defaults.update 'name' => basename }

    %w[.ico .png .svg].each do |extname|
      describe "when creating an asset with #{extname} extension" do
        let(:basename) { 'output' + extname }

        it 'creates a Jekyll::Favicon::Image asset instance if the name has ' \
           "a #{extname} extension" do
          subject.must_be_kind_of Jekyll::Favicon::Image
        end
      end
    end

    %w[.json .webmanifest].each do |extname|
      describe "when creating an asset with #{extname} extension" do
        let(:basename) { 'output' + extname }

        it 'creates a Jekyll::Favicon::Data asset instance if the name has' \
           "a #{extname} extension" do
          subject.must_be_kind_of Jekyll::Favicon::Data
        end
      end
    end

    %w[.xml].each do |extname|
      describe "when creating an asset with #{extname} extension" do
        let(:basename) { 'output' + extname }

        it 'creates a Jekyll::Favicon::Markup asset instance if the name has ' \
           "a #{extname} extension" do
          subject.must_be_kind_of Jekyll::Favicon::Markup
        end
      end
    end

    %w[.other-extension].each do |extname|
      describe "when creating an asset with invalid #{extname} extension" do
        let(:basename) { 'output' + extname }

        it 'does not create a Jekyll::Favicon::Asset instance if the name ' \
           "has a #{extname} extension" do
          subject.must_be_nil
        end
      end
    end
  end

  # describe '.config' do
  #   it 'is a public method' do
  #     Jekyll::Favicon.must_respond_to :config
  #   end
  #
  #   it 'deeply merges base favicon config with provided Hash' do
  #     config = Jekyll::Favicon.config {}
  #     config.must_be_kind_of Hash
  #     config.wont_be_empty
  #   end
  # end

  # describe '.defaults' do
  #   it 'is a public method' do
  #     Jekyll::Favicon.must_respond_to :defaults
  #   end
  #
  #   it 'provides a Hash containing favicon defaults' do
  #     defaults = Jekyll::Favicon.defaults
  #     defaults.must_be_kind_of Hash
  #     defaults.wont_be_empty
  #     defaults.keys.must_include 'processing'
  #     processing = defaults['processing']
  #     processing.must_be_kind_of Hash
  #     processing.wont_be_empty
  #   end
  # end

  describe '.assets' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :assets
    end

    it "maps config's assets to a collection of Jekyll::Favicon::Asset" do
      assets = Jekyll::Favicon.assets site
      assets.must_be_kind_of Array
      assets.wont_be_empty
      assets.each do |asset|
        asset.must_be_kind_of Jekyll::Favicon::Asset
      end
    end
  end

  describe '.sources' do
    it 'is a public method' do
      Jekyll::Favicon.must_respond_to :sources
    end

    it "collects the different source's names through all assets" do
      sources = Jekyll::Favicon.sources site
      sources.must_be_kind_of Set
      sources.wont_be_empty
    end
  end

  # describe '.references' do
  #   it 'is a public method' do
  #     Jekyll::Favicon.must_respond_to :references
  #   end
  #
  #   it 'collects and unifies all the references through all assets' do
  #     references = Jekyll::Favicon.references site
  #     references.must_be_kind_of Hash
  #     references.must_be_empty
  #   end
  # end
end
