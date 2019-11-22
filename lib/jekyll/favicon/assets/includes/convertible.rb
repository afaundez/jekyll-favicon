require 'mini_magick'

module Jekyll
  module Favicon
    # Add convert images
    module Convertible
      DEFAULTS = YAML.load_file File.join(__dir__, 'defaults', 'convert.yml')

      def self.included(_mod)
        attr_accessor :sizes, :options
      end

      def convertialize(sizes, background, options)
        @sizes = extract_sizes_from sizes
        global_options = {}
        global_options['background'] = background if background
        user_options = options || {}
        @options = build_options global_options, user_options
      end

      def convertible?
        @sizes && !@sizes.empty? || '.svg'.eql?(extname)
      end

      def convert(input, output)
        case File.extname output
        when '.svg' then FileUtils.cp input, output
        when '.ico', '.png'
          MiniMagick::Tool::Convert.new do |convert|
            append_properties convert
            convert << input
            convert << output
          end
        end
      end

      def extract_sizes_from(sizes)
        user_defined_sizes = sizes
        extracted_sizes = Utils.extract_sizes_from @name
        [user_defined_sizes || extracted_sizes].compact.flatten
      end

      def build_options(global_convert_options, user_convert_options)
        convert_input_options.merge(convert_output_options)
                             .merge(global_convert_options)
                             .merge(user_convert_options)
                             .merge(convert_extra_options)
                             .select { |_, value| value }
      end

      def joint_sizes(separator = ' ')
        @sizes.join separator if @sizes
      end

      private

      def append_properties(convert)
        properties_from do |property, value|
          convert.send property, value if value
        end
      end

      def properties_from(&block)
        basic(&block)
        resize(&block)
      end

      def basic(&block)
        yield :background, @options['background']
        define @options['define'], &block
        yield :density, @options['density']
        yield :alpha, @options['alpha']
      end

      def define(define_option)
        return unless define_option
        define_option.each do |option, key_value|
          key, value = key_value.first
          value = define_value if value == 'auto'
          yield :define, "#{option}:#{key}=#{value}"
        end
      end

      def define_value
        @sizes.collect { |size| size.split('x').first }.join(',')
      end

      def resize(&block)
        return unless (resize = @options['resize'])
        resize = @sizes.first if 'auto'.eql? resize
        yield :resize, resize
        weight, height = resize.split 'x'
        gravity resize, &block unless weight == height
      end

      def gravity(resize, &_block)
        yield :gravity, @options['gravity']
        yield :extent, resize
      end

      def convert_input_options
        DEFAULTS.fetch('input', {})
                .fetch(source_extname, {})
                .select { |_, value| value }
      end

      def convert_output_options
        DEFAULTS.fetch('output', {})
                .fetch(extname, {})
                .select { |_, value| value }
      end

      def convert_extra_options
        return {} if @sizes.empty? || extname.eql?('.ico')
        { 'resize' => joint_sizes }
      end
    end
  end
end
