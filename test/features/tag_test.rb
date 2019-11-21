require 'test_helper'

describe 'favicon tag execution' do
  describe 'favicon is a valid tag' do
    it 'is part of jekyll site tags' do
      Liquid::Template.tags['favicon'].must_equal Jekyll::Favicon::Tag
    end
  end

  describe 'when favicon tag is used' do
    around :all do |&block|
      Dir.mktmpdir do |tmpdir|
        @destination = tmpdir
        site.process
        super(&block)
      end
    end

    let(:config) do
      {
        'source' => fixture('sites', 'minimal-tag'),
        'destination' => destination,
        'favicon' => {
          'assets_override' => favicon_override,
          'assets' => favicon_assets
        }
      }
    end

    let(:destination) { @destination }
    let(:site) { Jekyll::Site.new Jekyll.configuration config }
    let(:tags) { Jekyll::Favicon.assets(site).collect(&:tags) }
    let(:link_pattern) { %r{<link .*/>} }
    let(:meta_pattern) { %r{<meta .*/>} }
    subject { File.read File.join @destination, 'index.html' }

    describe 'when user config is not provided' do
      let(:favicon_override) { false }
      let(:favicon_assets) { {} }
      it 'creates default tags' do
        subject.scan(link_pattern).size.must_equal 4
        subject.scan(meta_pattern).size.must_equal 3
        tags.flatten.each { |tag| subject.must_include tag.to_s }
      end
    end

    describe 'when user config is provided' do
      describe 'when user added new assets' do
        let(:favicon_override) { false }
        let(:favicon_assets) { { 'favicon-16x16.png' => { 'link' => {} } } }
        it 'add tags for new assets' do
          subject.scan(link_pattern).size.must_equal 5
          subject.scan(meta_pattern).size.must_equal 3
          tags.flatten.each { |tag| subject.must_include tag.to_s }
        end
      end

      describe 'when user overrides assets' do
        let(:favicon_override) { true }
        let(:favicon_assets) { { 'favicon-16x16.png' => { 'link' => {} } } }
        it 'create only user selected tags' do
          subject.scan(link_pattern).size.must_equal 1
          subject.scan(meta_pattern).size.must_equal 0
          tags.flatten.each { |tag| subject.must_include tag.to_s }
        end
      end
    end
  end
end
