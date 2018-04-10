Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::Favicon.merge site.config['favicon']
  site.config['exclude'] << Jekyll::Favicon.config['source']
end

Jekyll::Hooks.register :site, :post_write do |site|
  favicon_generators = site.generators.select do |generator|
    generator.is_a? Jekyll::Favicon::Generator
  end
  favicon_generators.each(&:clean)
end
