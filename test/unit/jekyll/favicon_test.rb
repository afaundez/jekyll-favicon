require 'test_helper'

module Jekyll
  describe Favicon do
    let(:source) { fixture 'sites', 'config' }
    let(:site) { Jekyll::Site.new Jekyll.configuration('source' => source) }

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

    describe '.site_assets_config' do
      it 'is a public method' do
        Jekyll::Favicon.must_respond_to :site_assets_config
      end
    end

    describe '.user_config' do
      it 'is a public method' do
        Jekyll::Favicon.must_respond_to :user_config
      end

      describe 'when key is present' do
        subject { Favicon.user_config site, key }

        describe 'and key is a valid attribute' do
          let(:key) { 'source' }

          it 'returns attribute value attribute is present' do
            subject.must_equal 'custom-source.svg'
          end
        end

        describe 'and key is a valid attribute' do
          let(:key) { 'invalid-output' }

          it 'returns nothing if attribute' do
            subject.must_be_nil
          end
        end
      end

      describe 'when key is not present' do
        let(:user_config) { YAML.load_file File.join source, '_config.yml' }
        subject { Favicon.user_config site }

        it 'returns whole user config if not attribute is present' do
          subject.must_equal user_config['favicon']
        end
      end
    end

    describe '.site_global_config' do
      it 'is a public method' do
        Jekyll::Favicon.must_respond_to :site_global_config
      end
    end

    describe '.user_global_config' do
      it 'is a public method' do
        Jekyll::Favicon.must_respond_to :user_global_config
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
  end
end
