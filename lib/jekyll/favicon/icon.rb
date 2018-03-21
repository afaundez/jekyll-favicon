module Jekyll
  module Favicon
    class Icon < Jekyll::StaticFile
      def initialize(site, base, dir, name, collection = nil)
        @site = site
        @base = base
        @dir  = dir
        @name = name
        @collection = collection
        @relative_path = File.join(*[@dir, name].compact)
        @extname = File.extname(@name)
        @data = {}
        @data['name'] = @name
        @data['layout'] = nil
      end

      def path
        File.join(*[@base, Favicon.config['source']].compact)
      end

      private
      def copy_file(dest_path)
        MiniMagick::Tool::Convert.new do |convert|
          convert << path
          convert.merge! ['-background', 'none', '-density', '1000']
          convert.merge! case @extname
          when '.ico'
            ['-define', 'icon:auto-resize=256,128,64,48,32,16']
          when '.png'
            w, h = @name[/favicon-(\d+x\d+).png/, 1].split('x').collect(&:to_i)
            size = w < h ? h : w
            if w != h
              ['-crop', "#{w}x#{h}#{"+#{(size - w)/2}+#{(size - h)/2}" if w != h}"]
            else
              ['-resize', "#{w}x#{h}"]
            end
          when '.svg'
            []
          end
          convert << dest_path
        end
      end
    end
  end
end
