module Jekyll
  module Favicon
    class Icon < Jekyll::StaticFile
      attr_accessor :source

      def initialize(site, base, dir, name, source, collection = nil)
        @site = site
        @base = base
        @dir  = dir
        @name = name
        @source = source
        @collection = collection
        @relative_path = File.join(*[@dir, name].compact)
        @extname = File.extname(@name)
        @data = {}
        @data['name'] = @name
        @data['layout'] = nil
      end

      def path
        source
      end

      private

      def copy_file(dest_path)
        case @extname
        when '.ico'
          define = "icon:auto-resize=#{Favicon.config['ico']['sizes'].join ','}"
        when '.png'
          w, h = @name[/favicon-(\d+x\d+).png/, 1].split('x').collect(&:to_i)
          odd = true if w != h
          resize = "#{w}x#{h}"
        when '.svg'
          FileUtils.cp path, dest_path
          return
        else
          Jekyll.logger.warn "Jekyll::Favicon: Can't generate #{dest_path}, extension not supported supported."
          return
        end
        MiniMagick::Tool::Convert.new do |convert|
          convert << path
          convert.background Favicon.config['background']
          convert.gravity 'center' if resize && odd
          convert.define define if define
          convert.resize resize if resize
          convert.extent resize if resize && odd
          convert << dest_path
        end
      end
    end
  end
end
