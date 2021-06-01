# frozen_string_literal: true

require 'pathname'
require 'forwardable'
require 'jekyll/static_file'
require 'jekyll/favicon/static_file/sourceable'
require 'jekyll/favicon/static_file/taggable'
require 'jekyll/favicon/static_file/referenceable'
require 'jekyll/favicon/utils'
require 'jekyll/favicon/configuration'

module Jekyll
  module Favicon
    # Class for static files from with spec dictionary
    # Modify source from spec source
    # Enable tags from spec tags
    # Enable refer
    class StaticFile < Jekyll::StaticFile
      include StaticFile::Sourceable
      include StaticFile::Taggable
      include StaticFile::Referenceable

      attr_reader :spec, :site

      def initialize(site, spec = {})
        raise StandardError unless spec.include? 'name'

        @spec = spec
        spec_dir, spec_name = File.split spec_relative_path
        super site, site.source, spec_dir, spec_name
      end

      def generable?
        sourceable?
      end

      def taggable?
        generable? && super
      end

      def patch(configuration)
        taggable_patch spec_patch configuration
      end

      def href
        Pathname.new('/')
                .join(*[site.baseurl, url].compact)
                .to_s
      end

      private

      def spec_patch(configuration)
        Utils.patch configuration do |value|
          case value
          when :site_dir then site_dir
          when :background then site_background
          when :href then href
          else value
          end
        end
      end

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
