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

      describe '.build' do
        subject { Asset.build site, attributes }
        let(:site) { Jekyll::Site.new Jekyll.configuration }
        let(:defaults) { { 'source' => 'source.svg', 'dir' => 'pathname' } }
        let(:attributes) { defaults.update 'name' => basename }

        it 'is a public method' do
          Asset.must_respond_to :build
        end

        %w[.ico .png .svg].each do |extname|
          describe "when creating an asset with #{extname} extension" do
            let(:basename) { 'output' + extname }

            it 'creates a Jekyll::Favicon::Image asset instance ' \
               "if the name has a #{extname} extension" do
              subject.must_be_kind_of Jekyll::Favicon::Image
            end
          end
        end

        %w[.json .webmanifest].each do |extname|
          describe "when creating an asset with #{extname} extension" do
            let(:basename) { 'output' + extname }

            it 'creates a Jekyll::Favicon::Data asset instance ' \
               "if the name hasa #{extname} extension" do
              subject.must_be_kind_of Jekyll::Favicon::Data
            end
          end
        end

        %w[.xml].each do |extname|
          describe "when creating an asset with #{extname} extension" do
            let(:basename) { 'output' + extname }

            it 'creates a Jekyll::Favicon::Markup asset instance ' \
               "if the name has a #{extname} extension" do
              subject.must_be_kind_of Jekyll::Favicon::Markup
            end
          end
        end

        %w[.other-extension].each do |extname|
          describe "when creating an asset with invalid #{extname} extension" do
            let(:basename) { 'output' + extname }

            it 'does not create a Jekyll::Favicon::Asset instance ' \
               "if the name has a #{extname} extension" do
              subject.must_be_nil
            end
          end
        end
      end
    end
  end
end
