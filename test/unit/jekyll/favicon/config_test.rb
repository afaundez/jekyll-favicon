require 'test_helper'

module Jekyll
  module Favicon
    describe Config do
      it 'has public method transform' do
        Config.must_respond_to :transform
      end

      describe '.transform' do
        let(:key) { nil }
        subject { Config.transform base, key: key }

        describe 'when base is nil' do
          let(:base) {}

          it 'returns an empty array' do
            subject.must_be_kind_of Array
            subject.must_be_empty
          end
        end

        # describe 'when base is an array' do
        #   describe 'and base is empty' do
        #     let(:base) { [] }
        #     subject { Config.transform base }
        #
        #     it 'returns an empty array' do
        #       subject.must_be_kind_of Array
        #       subject.must_be_empty
        #     end
        #   end
        # end

        describe 'when base is a hash' do
          describe 'and base is empty' do
            let(:base) { {} }

            it 'transforms to an empty array' do
              subject.must_be_kind_of Array
              subject.must_be_empty
            end
          end

          describe 'and base is present' do
            describe 'and no key is provided' do
              let(:base) { { 'skip-this' => nil, 'favicon-1x1.png' => '' } }

              it 'return the base within an array' do
                subject.must_be_kind_of Array
                subject.size.must_equal 1
                subject.first.must_equal base
              end
            end

            describe 'and key is provided' do
              describe 'and non empty key is provided' do
                let(:key) { 'some-key' }

                describe 'and value is a hash' do
                  let(:base) { { 'key1' => { 'key2' => 'value1' } } }

                  it 'transform base key to new value an merge with value' do
                    subject.must_be_kind_of Array
                    subject.size.must_equal 1
                    item = subject.first
                    item.size.must_equal 2
                    item.keys.must_include key
                    item.keys.must_include base.values.first.keys.first
                  end
                end

                describe 'and value is a string' do
                  let(:base) { { 'key' => 'value' } }

                  it 'uses value as new key' do
                    subject.must_be_kind_of Array
                    subject.size.must_equal 1
                    item = subject.first
                    item.size.must_equal 2
                    item.keys.must_include key
                    value = base.values.first
                    item.keys.must_include value
                    item[value].must_equal true
                  end
                end

                describe 'and value is nil' do
                  let(:base) { { 'key' => nil } }

                  it 'transforms to hash only with key in an array' do
                    subject.must_be_kind_of Array
                    subject.size.must_equal 1
                    item = subject.first
                    item.size.must_equal 1
                    item.keys.must_include key
                    item.values.must_equal base.keys
                  end
                end
              end
            end
          end
        end

        # describe 'when base is a hash and no key is provided' do
        #   describe 'and base is present' do
        #
        #     describe 'and key is provided' do
        #     end
        #
        #     describe 'and value is string' do
        #       let(:base) { { 'favicon-1x1.png' => '' } }
        #
        #       it 'transforms to array of hashes' do
        #         subject.must_be_kind_of Array
        #         subject.size.must_equal 1
        #         subject.first.must_be_kind_of Hash
        #       end
        #
        #
        #       end
        #     end
        #
        #     describe 'and value is hash' do
        #       let(:base) { { 'favicon-1x1.png' => { 'rel' => 'icon' } } }
        #
        #       describe 'when no key is provided' do
        #         subject { Config.transform base }
        #
        #         it 'returns an array with the same hash' do
        #           subject.must_be_kind_of Array
        #           subject.size.must_equal 1
        #           subject.first.must_be_kind_of Hash
        #         end
        #       end
        #
        #       describe 'when key is provided and is not in the base' do
        #         let(:key) { 'name' }
        #         subject { Config.transform base, key }
        #
        #         it 'returns an array of hashes, one for each key in base' do
        #           subject.must_be_kind_of Array
        #           subject.size.must_equal base.size
        #           base.each do |base_key, value|
        #             item = subject.find { |s| s.values.include? base_key }
        #             item.must_be_kind_of Hash
        #             item.keys.must_include key
        #             item.keys.wont_include base_key
        #             value.each do |k, v|
        #               item.keys.must_include k
        #               item[k].must_equal v
        #             end
        #           end
        #         end
        #       end
        #     end
        #   end
        # end

        # describe 'when base is an string' do
        #   describe 'and base is empty' do
        #     let(:base) { '' }
        #
        #     it 'transforms to nil' do
        #       subject.must_be_nil
        #     end
        #
        #     describe 'and key is present' do
        #       subject { Config.transform base, 'some-key' }
        #
        #       it 'transforms to nil' do
        #         subject.must_be_nil
        #       end
        #     end
        #   end
        #
        #   describe 'and base is present' do
        #     let(:base) { 'some-base' }
        #
        #     it 'transforms to nil' do
        #       subject.must_be_nil
        #     end
        #
        #     describe 'and key is present' do
        #       subject { Config.transform base, 'some-key' }
        #
        #       it 'transforms to hash with one key-value' do
        #         subject.must_be_kind_of Hash
        #         subject.size.must_equal 1
        #         subject.must_equal 'some-key' => 'some-base'
        #       end
        #     end
        #   end
        # end
      end
    end
  end
end
