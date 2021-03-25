# frozen_string_literal: true

Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::Favicon.sources(site).each do |source|
    site.config['exclude'] << source
  end
end
