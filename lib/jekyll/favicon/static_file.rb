# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'forwardable'
require 'jekyll/static_file'
require 'jekyll/favicon'
require 'jekyll/favicon/configuration'

module Jekyll
  module Favicon
    # Class for static files from with spec dictionary
    class StaticFile < Jekyll::StaticFile
      attr_reader :spec, :site

      def initialize(site, spec = {})
        raise StandardError unless spec.include? 'name'

        @spec = spec
        spec_dir, spec_name = File.split spec_relative_path
        super site, site.source, spec_dir, spec_name
      end

      def patch(configuration)
        Favicon::Utils.patch configuration do |value|
          case value
          when :background then site_background
          when :href then href
          else value
          end
        end
      end

      def href
        Pathname.new('/')
                .join(url)
                .to_s
      end

      private

      def site_dir
        site_configuration.fetch('dir', '.')
      end

      def site_background
        site_configuration.fetch('background', 'transparent')
      end

      def site_configuration
        Configuration.merged site
      end

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

      def spec_dir_name
        spec.values_at('dir', 'name')
            .compact
      end
    end
  end
end
