# frozen_string_literal: true

require "jekyll/hooks"

Jekyll::Hooks.register :site, :after_init do |site|
  static_files = Jekyll::Favicon.assets(site)
    .uniq(&:path)
  excludes = site.config["exclude"]
  static_files.each do |static_file|
    source = static_file.source_relative_path
    excludes << source and next if static_file.generable?

    Jekyll.logger.warn Jekyll::Favicon,
      "Missing #{source}, not generating favicons."
  end
end
