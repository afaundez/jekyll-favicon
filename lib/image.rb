# Build browserconfig XML
module Image
  def self.convert(source, output, options = {})
    MiniMagick::Tool::Convert.new do |convert|
      options_for convert, options
      convert << source
      convert << output
    end
  end

  def self.options_for(convert, options)
    convert.flatten
    basic_options convert, options
    resize_options convert, options
    odd_options convert, options
  end

  def self.basic_options(convert, options)
    convert.background options[:background] if options[:background]
    convert.define options[:define] if options[:define]
    convert.density options[:density] if options[:density]
    convert.alpha options[:alpha] if options[:alpha]
  end

  def self.resize_options(convert, options)
    convert.resize options[:resize] if options[:resize]
  end

  def self.odd_options(convert, options)
    convert.gravity 'center' if options[:odd]
    convert.extent options[:resize] if options[:odd] && options[:resize]
  end
end
