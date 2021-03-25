# frozen_string_literal: true

require 'yaml'

module Jekyll
  module Favicon
    # Favicon configuration
    module Configuration
      CONFIG_ROOT = Favicon::GEM_ROOT.join 'lib', 'jekyll', 'favicon', 'config'

      # def self.defaults
      #   YAML.load_file CONFIG_ROOT.join('favicon.yml')
      # end

      def self.custom(site)
        site&.config&.fetch 'favicon', {}
      end

      def self.merged(site)
        site_favicon_config = custom site
        return defaults unless site_favicon_config

        standardize Favicon::Utils.merge(Favicon::DEFAULTS, unlegacify(site_favicon_config))
      end

      def self.asset(concern)
        concern_path = CONFIG_ROOT.join 'asset', "#{concern}.yml"
        YAML.load_file concern_path
      end

      def self.unlegacify(config)
        options = config.slice 'source', 'dir', 'background', 'assets'
        path = options['path']
        options['dir'] ||= path if path
        options
      end

      def self.standardize(config)
        config['source'] = standardize_source config['source']
        config
      end

      def self.standardize_source_string(source)
        dir, name = File.split source
        { 'name' => name, 'dir' => dir }
      end

      def self.pathname(*paths)
        Pathname.new(File.join(*paths.compact)).cleanpath.to_s
      end

      def self.standardize_source_hash(source)
        name_dir, name = File.split source['name']
        dir = source['dir']
        source_dir = dir && !dir.empty? ? dir : nil
        { 'name' => name, 'dir' => pathname(source_dir, name_dir) }
      end

      def self.standardize_source(source)
        case source
        when String then standardize_source_string source
        when Hash then standardize_source_hash source
        end
      end
    end
  end
end
