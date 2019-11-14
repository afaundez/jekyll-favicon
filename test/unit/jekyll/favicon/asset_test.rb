require 'test_helper'

module Jekyll
  module Favicon
    describe Asset do
      subject { Asset.included_modules }

      it 'is mappeable' do
        subject.must_include Mappeable
      end

      it 'is sourceable' do
        subject.must_include Sourceable
      end

      it 'is referenceable' do
        subject.must_include Referenceable
      end

      it 'is taggable' do
        subject.must_include Taggable
      end

      describe '.new' do
        let(:site) { Jekyll::Site.new Jekyll.configuration }
        let(:base) { site.source }
        let(:dir) { '' }
        let(:basename) { 'basename.extname' }
        let(:attributes) do
          { 'source' => 'filename', 'dir' => '', 'name' => 'filename' }
        end

        describe 'when no asset parameters provided' do
          subject { Asset.new site, attributes }

          it 'is a Jekyll::StaticFile instance' do
            subject.must_be_kind_of Jekyll::StaticFile
          end

          it 'is not sourceable' do
            subject.sourceable?.must_equal false
          end
        end
      end
    end
  end
end
