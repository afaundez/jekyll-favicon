require 'test_helper'

module Jekyll
  module Favicon
    describe Generator do
      describe '.generate' do
        it 'a private method' do
          Tag.wont_respond_to :generate
          Tag.must_respond_to :send, :generate
        end
      end
    end
  end
end
