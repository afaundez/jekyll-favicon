# frozen_string_literal: true

require "jekyll/utils"

module Jekyll
  module Favicon
    # Favicon configuration
    module Configuration
      def self.merged(site)
        return from_defaults unless (user_overrides = from_user site)

        user_overrides = unlegacify user_overrides
        user_merged = Jekyll::Utils.deep_merge_hashes from_defaults,
          user_overrides
        standardize user_merged
      end

      def self.from_user(site)
        site&.config&.fetch "favicon", {}
      end

      def self.from_defaults
        Favicon.defaults
      end

      def self.standardize(config)
        return unless config

        config.merge "source" => standardize_source(config["source"])
      end

      def self.standardize_source(source)
        case source
        when String then standardize_source_string source
        when Hash then standardize_source_hash source
        end
      end

      private_class_method :standardize_source

      def self.standardize_source_string(source)
        dir, name = File.split source
        {"name" => name, "dir" => dir}
      end

      private_class_method :standardize_source_string

      def self.standardize_source_hash(source)
        name_dir, name = File.split source["name"]
        dir = source["dir"]
        source_dir = dir && !dir.empty? ? dir : nil
        {"name" => name, "dir" => standardize_pathname(source_dir, name_dir)}
      end

      private_class_method :standardize_source_hash

      def self.standardize_pathname(*paths)
        Pathname.new(File.join(*paths.compact)).cleanpath.to_s
      end

      private_class_method :standardize_source_string

      def self.unlegacify(config)
        options = config.slice "source", "dir", "background", "assets"
        path = options["path"]
        options["dir"] ||= path if path
        options
      end

      private_class_method :unlegacify
    end
  end
end
