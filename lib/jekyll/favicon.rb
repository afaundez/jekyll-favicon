require 'yaml'

module Jekyll
  # build and provide config, assets and related
  module Favicon
    config_path = Pathname.new File.join(__dir__, 'favicon', 'config')
    DEFAULT_GLOBAL_ATTRIBUTES = YAML.load_file config_path.join 'global.yml'
    DEFAULT_ASSETS = YAML.load_file config_path.join 'assets.yml'

    def self.assets(site)
      user_config = site.config.fetch 'favicon', {}
      user_global_attributes = user_config.select do |attribute, _|
        DEFAULT_GLOBAL_ATTRIBUTES.key? attribute
      end
      global_attributes = DEFAULT_GLOBAL_ATTRIBUTES.merge user_global_attributes
      user_assets = user_config.fetch 'assets', {}
      assets_customizations = if user_config['override'] then user_assets
                              else Utils.merge DEFAULT_ASSETS, user_assets
                              end
      create_assets site, assets_customizations, global_attributes
    end

    def self.sources(site)
      assets(site).reduce(Set[]) { |sources, asset| sources.add asset.source }
    end

    def self.create_assets(site, config, base_values = {})
      items = Config.transform config, key: 'name', base_values: base_values
      items.collect { |item| create_asset site, item }.compact
    end
    private_class_method :create_assets

    def self.create_asset(site, attributes)
      return if attributes['skip']
      asset = case File.extname attributes['name']
              when *Data::MAPPINGS.values.flatten then Data
              when *Image::MAPPINGS.values.flatten then Image
              when *Markup::MAPPINGS.values.flatten then Markup
              else return nil
              end
      asset.new site, attributes
    end
    private_class_method :create_asset
  end
end
