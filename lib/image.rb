# frozen_string_literal: true

require 'mini_magick'

# Build browserconfig XML
module Image
  def self.convert(source, output, options = {})
    MiniMagick::Tool::Convert.new do |convert|
      if File.extname(source) == '.svg' && options.key?('background')
        if options['background'] == 'transparent'
          convert.background 'none' 
          options.delete 'background'
        else
          convert.background options.delete('background')
        end
      end
      convert << source
      options_for convert, options
      convert << output
    end
  end

  def self.options_for(convert, options)
    convert.flatten
    options.each do |option, value|
      convert.send option.to_sym, value
    end
  end
end
