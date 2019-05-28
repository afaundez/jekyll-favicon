module Jekyll
  module Favicon
    # Add source reference to a static file
    module Sourceable
      include Mappeable

      def self.included(_mod)
        attr_accessor :source, :base
      end

      def sourceabilize(source)
        @base ||= ''
        @source = source
      end

      def generate(_dest_path)
        raise NotImplementedError, 'A sourceable must implement #generate'
      end

      def sourceable?
        !path.nil? && File.file?(path)
      end

      def source_extname
        File.extname @source if @source.respond_to? :to_str
      end

      def source_dir
        File.dirname @source if @source.respond_to? :to_str
      end

      def source_name
        File.basename @source if @source.respond_to? :to_str
      end

      def source_data
        File.read path if sourceable?
      end

      def path
        return unless @source
        File.expand_path File.join(*[@base, source_dir, source_name].compact)
      end

      def modified_time
        @modified_time ||= sourceable? ? super : Time.now
      end

      def modified?
        sourceable? && self.class.mtimes[path] != mtime
      end

      private

      def copy_file(dest_path)
        generate dest_path
        return if File.symlink? dest_path
        File.utime self.class.mtimes[path], self.class.mtimes[path], dest_path
      end
    end
  end
end
