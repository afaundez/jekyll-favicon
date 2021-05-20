# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'forwardable'
require 'jekyll/static_file'
require 'jekyll/favicon'
require 'jekyll/favicon/configuration/yamleable'
require 'jekyll/favicon/configuration'

module Jekyll
  module Favicon
    # StaticFile extension with extra config variable with attributes
    class StaticFile < Jekyll::StaticFile
      include Configuration::YAMLeable

      attr_reader :spec, :site

      def initialize(site, spec = {})
        raise StandardError unless spec.include? 'name'

        @spec = spec
        dir, name = File.split spec_relative_path
        super site, site.source, dir, name
      end

      def patch(configuration)
        Favicon::Utils.patch configuration do |value|
          case value
          when :background then site_background
          when :dir then site_dir
          when :url then url_path
          else value
          end
        end
      end

      private

      def spec_relative_path
        spec_relative_pathname.cleanpath
      end

      def spec_relative_pathname
        return spec_pathname if spec_pathname.relative?

        pathname.relative_path_from '/'
      end

      def spec_pathname
        Pathname.new(site_dir)
                .join(*spec_dir_name)
      end

      def site_dir
        Configuration.merged(site).fetch 'dir', '.'
      end

      def spec_dir_name
        @spec.values_at('dir', 'name')
             .compact
      end

      def url_path
        Pathname.new('/')
                .join(url)
                .to_s
      end

      def site_background
        Configuration.merged(site).fetch 'background', 'transparent'
      end
    end
  end
end
