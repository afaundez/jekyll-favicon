require 'test_helper'

module Jekyll
  module Favicon
    describe Sourceable do
      subject { Object.new.extend Sourceable }

      it 'has source attibute' do
        subject.must_respond_to :source
      end

      it 'has base attibute' do
        subject.must_respond_to :base
      end

      describe '.sourceabilize' do
        before { subject.sourceabilize 'value' }

        it 'sets source attribute' do
          subject.source.must_equal 'value'
        end
      end

      describe '.generate' do
        it 'raises NotImplementedError when trying to generate' do
          -> { subject.generate nil }.must_raise NotImplementedError
        end
      end

      describe '.sourceable?' do
        it 'returns false if not sourceabilized' do
          subject.sourceable?.must_equal false
        end

        describe 'when sourceabilized' do
          before { subject.sourceabilize source }

          describe 'when sourceabilized with nil source' do
            let(:source) { nil }

            it 'returns false' do
              subject.sourceable?.must_equal false
            end
          end

          describe 'when sourceabilized with not existing source' do
            let(:source) { 'non-existing-source' }

            it 'returns false' do
              subject.sourceable?.must_equal false
            end
          end

          describe 'when sourceabilized with existing source' do
            let(:source) { fixture 'sites', 'minimal-generator', 'favicon.svg' }

            it 'returns true' do
              subject.sourceable?.must_equal true
            end
          end
        end
      end

      describe '.source_extname' do
        describe 'when @source is nil' do
          before { subject.sourceabilize nil }

          it 'return nil' do
            subject.source_extname.must_be_nil
          end
        end

        describe 'when @source is convertible implicitly to string' do
          before { subject.sourceabilize 'value' }

          it 'returns a extension' do
            subject.source_extname.must_equal ''
          end
        end
      end

      describe '.source_dir' do
        describe 'when @source is nil' do
          before { subject.sourceabilize nil }

          it 'return nil' do
            subject.source_dir.must_be_nil
          end
        end

        describe 'when @source is convertible implicitly to string' do
          before { subject.sourceabilize 'value' }

          it 'returns a path' do
            subject.source_dir.must_equal '.'
          end
        end
      end

      describe '.source_name' do
        describe 'when @source is nil' do
          before { subject.sourceabilize nil }

          it 'return nil' do
            subject.source_name.must_be_nil
          end
        end

        describe 'when @source is convertible implicitly to string' do
          before { subject.sourceabilize 'value' }

          it 'returns a name' do
            subject.source_name.must_equal 'value'
          end
        end
      end

      describe 'source_data' do
        describe 'when @source is nil' do
          before { subject.sourceabilize nil }

          it 'return nil' do
            subject.source_name.must_be_nil
          end
        end

        describe 'when @source is convertible implicitly to string' do
          before { subject.sourceabilize 'value' }

          it 'returns a name' do
            subject.source_name.wont_be_nil
          end
        end
      end

      describe '.modified_time' do
      end

      describe '.modified?' do
      end

      describe '.path' do
        it 'returns nil if not sourceabilized' do
          subject.path.must_be_nil
        end

        describe 'when sourceabilized' do
          before { subject.sourceabilize source }

          describe 'and source contains a relative path' do
            let(:source) { 'path/basename' }

            it 'returns a valid path' do
              subject.path.must_equal "/#{source}"
            end
          end

          describe 'and source contains a absolute path' do
            let(:source) { '/path/basename' }

            it 'returns a valid path' do
              subject.path.must_equal source
            end
          end

          describe 'and source does not contains a path' do
            let(:source) { 'basename' }

            it 'returns a valid path' do
              subject.path.must_equal "/#{source}"
            end
          end
        end
      end

      describe '.copy_file' do
      end
    end
  end
end
