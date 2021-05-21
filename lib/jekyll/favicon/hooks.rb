# frozen_string_literal: true

require 'jekyll/hooks'

Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::Favicon.assets(site)
                 .uniq(&:path)
                 .each_with_object site.config['exclude'] do |asset, memo|
                   source = asset.source_relative_path
                   next memo.push(source) if asset.generable?

                   Jekyll.logger.warn(Jekyll::Favicon) do
                     "Missing #{source}, not generating favicons."
                   end
                 end
end
