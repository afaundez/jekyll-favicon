Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::Favicon.merge site.config['favicon']
  site.config['exclude'] << Jekyll::Favicon.config['source']
end
