# frozen_string_literal: true

Jekyll::Hooks.register :site, :after_init do |site|
  favicon_config = Jekyll::Favicon.merge site.config['favicon']
  site.config['exclude'] << favicon_config['source']
  site.config['exclude'] << favicon_config['chrome']['manifest']['source']
  site.config['exclude'] << favicon_config['ie']['browserconfig']['source']
end
