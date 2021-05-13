# frozen_string_literal: true

require 'mini_magick'

module Jekyll
  module Favicon
    module Utils
      # Favicon convert for include
      module Convert
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        # Favicon convert utils functions
        module ClassMethods
          def convert(input, output, options = {})
            MiniMagick::Tool::Convert.new do |convert|
              convert_options(convert, options) << input << output
            end
          end

          private

          def convert_options(convert, options = {})
            priorities = %w[resize scale]
            convert.flatten
            convert_apply convert, options.slice(*priorities)
            convert_apply convert, options.except(*priorities)
          end

          # :reek:UtilityFunction
          def convert_apply(convert, options = {})
            options.each_with_object(convert) do |(option, value), memo|
              memo.send option.to_sym, value
            end
          end
        end
      end
    end
  end
end
