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

        def self.convert_apply(convert, options = {})
          options.each_with_object(convert) do |(option, value), memo|
            memo.send option.to_sym, value
          end
        end

        def self.convert_options(convert, options = {})
          priorities = %w[resize scale]
          convert_apply convert, options.slice(*priorities)
          common_options = options.reject { |key| priorities.include? key }
          convert_apply convert, common_options
        end

        # Favicon convert utils functions
        module ClassMethods
          def convert(input, output, options = {})
            MiniMagick::Tool::Convert.new do |convert|
              convert.flatten
              Convert.convert_options(convert, options) << input << output
            end
          end
        end
      end
    end
  end
end
