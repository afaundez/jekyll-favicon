module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Icon < Jekyll::StaticFile
      attr_accessor :source

      def initialize(site, dir, name, source, collection = nil)
        @site = site
        @base = @site.source
        @dir  = dir
        @name = name
        @source = source
        @collection = collection
        @relative_path = File.join(*[@dir, name].compact)
        @extname = File.extname(@name)
        @data = { 'name' => @name, 'layout' => nil }
      end

      def path
        source
      end

      private

      def copy_file(dest_path)
        case @extname
        when '.svg' then FileUtils.cp path, dest_path
        when '.ico' then convert path, dest_path, ico_options
        when '.png' then convert path, dest_path, png_options
        else Jekyll.logger.warn "Jekyll::Favicon: Can't generate" \
                             " #{dest_path}, extension not supported supported."
        end
      end

      def dimensions
        @name[/favicon-(\d+x\d+).png/, 1].split('x').collect(&:to_i)
      end

      def png_options
        options = {}
        options[:background] = Favicon.config['background']
        w, h = dimensions
        options[:odd] = w != h
        options[:resize] = dimensions.join('x')
        options
      end

      def ico_options
        options = {}
        options[:background] = Favicon.config['background']
        ico_sizes = Favicon.config['ico']['sizes'].join ','
        options[:define] = "icon:auto-resize=#{ico_sizes}"
        options
      end

      def convert(input, output, options = {})
        MiniMagick::Tool::Convert.new do |convert|
          options_for convert, options
          convert << input
          convert << output
        end
      end

      def options_for(convert, options)
        convert.background Favicon.config['background']
        convert.define options[:define] if options[:define]
        return unless options[:resize]
        convert.resize options[:resize]
        return unless options[:odd]
        convert.gravity 'center'
        convert.extent options[:resize]
      end
    end
  end
end
