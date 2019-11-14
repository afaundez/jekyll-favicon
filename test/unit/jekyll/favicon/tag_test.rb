require 'test_helper'

module Jekyll
  module Favicon
    describe Tag do
      let(:tag) { Tag.parse '', nil, nil, Liquid::ParseContext.new }
      subject { tag.render context }

      describe '.render' do
        around :all do |&block|
          site.generate
          super(&block)
        end

        let(:config) do
          {
            'source' => fixture('sites', 'minimal-generator'),
            'destination' => '/dev/null',
            'favicon' => {
              'override' => favicon_override,
              'assets' => favicon_assets
            }
          }
        end

        let(:site) { Jekyll::Site.new Jekyll.configuration config }
        let(:context) { Liquid::Context.new({}, {}, site: site) }

        describe 'when the site does not have assets' do
          let(:favicon_override) { true }
          let(:favicon_assets) {}

          it 'render nothing' do
            subject.must_be_empty
          end
        end

        describe 'when the site has an empty asset' do
          let(:favicon_override) { true }
          let(:favicon_assets) { { 'favicon-128x128.ico' => '' } }

          it 'wont render anything' do
            subject.must_be_empty
          end
        end

        describe 'when the site has a custom asset' do
          let(:favicon_override) { true }
          let(:favicon_assets) { { 'favicon-16x16.ico' => { 'link' => {} } } }

          it 'render the custom asset' do
            element = REXML::Element.new 'link'
            element.add_attributes 'href' => '/favicon-16x16.ico',
                                   'rel' => 'icon',
                                   'type' => 'image/x-icon'
            subject.wont_be_empty
            subject.must_equal element.to_s
          end
        end

        describe 'when the site has an invalid asset' do
          let(:favicon_override) { true }
          let(:favicon_assets) { { 'favicon.ico' => '' } }

          it 'render something' do
            subject.must_be_empty
          end
        end

        describe 'when the site has the base assets' do
          let(:favicon_override) { false }
          let(:favicon_assets) { {} }

          it 'render all default assets' do
            subject.wont_be_empty
          end
        end
      end
    end
  end
end
