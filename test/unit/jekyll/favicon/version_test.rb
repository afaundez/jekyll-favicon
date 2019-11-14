require 'test_helper'

module Jekyll
  describe 'Favicon' do
    it 'has a version number' do
      Jekyll::Favicon::VERSION.wont_be_nil
    end
  end
end
