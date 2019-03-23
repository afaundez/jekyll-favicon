module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Icon < Jekyll::StaticFile
      attr_accessor :replica
      attr_accessor :target

      def initialize(site, source, replica, target, collection = nil)
        @site = site
        @base = @site.source
        @dir  = File.dirname source
        @name = File.basename source
        @replica = replica
        @target = target
        @collection = collection
        @relative_path = File.join(*[@dir, @name].compact)
        @extname = File.extname(target)
        @data = { 'name' => File.basename(target), 'layout' => nil }
      end

      def destination(dest)
        basename = File.basename(@target)
        @site.in_dest_dir(*[dest, destination_rel_dir, basename].compact)
      end

      def destination_rel_dir
        File.dirname @target
      end

      private

      def copy_file(dest_path)
        case @extname
        when '.svg' then FileUtils.cp @replica, dest_path
        when '.ico' then Image.convert @replica, dest_path, ico_options
        when '.png' then Image.convert @replica, dest_path, png_options
        else Jekyll.logger.warn "Jekyll::Favicon: Can't generate" \
                             " #{dest_path}, extension not supported supported."
        end
      end

      def dimensions
        basename = File.basename(@target)
        basename[/favicon-(\d+x\d+).png/, 1].split('x').collect(&:to_i)
      end

      def png_options
        options = {}
        w, h = dimensions
        options[:background] = background_for dimensions
        options[:odd] = w != h
        options[:resize] = dimensions.join('x')
        options
      end

      def ico_options
        options = {}
        sizes = Favicon.config['ico']['sizes']
        options[:background] = background_for sizes.first
        options[:resize] = sizes.first
        ico_sizes = sizes.collect { |size| size.split('x').first }.join ','
        options[:define] = "icon:auto-resize=#{ico_sizes}"
        options
      end

      def background_for(size)
        category = Favicon.config['apple-touch-icon']
        return category['background'] if category['sizes'].include? size
        Favicon.config['background']
      end
    end
  end
end
