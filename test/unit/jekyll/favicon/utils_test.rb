require 'test_helper'

module Jekyll
  module Favicon
    describe Utils do
      describe '.merge' do
        it 'has public method merge' do
          Utils.must_respond_to :merge
        end

        let(:base) { { a: { b: { c: [1] } } } }
        let(:custom) { { a: { b: { c: [2], d: 3 } } } }

        it 'joins two hashes if no override parameter is used' do
          merged = Utils.merge base, custom
          merged.must_equal a: { b: { c: [1, 2], d: 3 } }
        end

        it 'merge and replaces values from the right into the left ' \
           'if the override is provided' do
          merged = Utils.merge base, custom, override: true
          merged.must_equal a: { b: { c: [2], d: 3 } }
        end
      end
    end
  end
end
