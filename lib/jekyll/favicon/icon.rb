# frozen_string_literal: true

require 'image'

module Jekyll
  module Favicon
    # Extended static file that generates multpiple favicons
    class Icon < Jekyll::StaticFile
      attr_reader :site, :asset

      def initialize(site, asset)
        @asset = asset
        source_dir, source_name = File.split @asset.source
        super site, site.source, source_dir, source_name
        @extname = File.extname @asset.target
      end

      def destination(dest)
        basename = File.basename @asset.target
        @site.in_dest_dir(*[dest, destination_rel_dir, basename].compact)
      end

      def destination_rel_dir
        File.dirname @asset.target
      end

      private

      def copy_file(dest_path)
        case File.extname @asset.target
        when '.svg' then FileUtils.cp path, dest_path
        when '.ico', '.png' then Image.convert path, dest_path, @asset.convertible
        else Jekyll.logger.warn "Jekyll::Favicon: Can't generate" \
                             " #{dest_path}, extension not supported supported."
        end
      end
    end
  end
end
