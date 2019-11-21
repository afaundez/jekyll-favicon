require 'yaml'

module Jekyll
  # build and provide config, assets and related
  module Favicon
    config_path = Pathname.new File.join(__dir__, 'favicon', 'config')
    GLOBAL_CONFIG = YAML.load_file config_path.join 'global.yml'
    ASSETS_CONFIG = YAML.load_file config_path.join 'assets.yml'

    def self.assets(site)
      assets = site_assets_config user_config(site, 'assets'),
                                  user_config(site, 'assets_override')
      global = site_global_config user_global_config(site)
      assets = Config.transform assets, key: 'name', base_values: global
      assets.collect { |asset| Asset.build site, asset }.compact
    end

    def self.site_assets_config(user_assets, user_assets_override)
      return user_assets if user_assets_override
      Utils.merge ASSETS_CONFIG, user_assets
    end

    def self.user_config(site, key = nil)
      user_config = site.config.fetch 'favicon', {}
      return user_config unless key
      user_config.fetch key, nil
    end

    def self.site_global_config(user_global_config)
      GLOBAL_CONFIG.merge user_global_config
    end

    def self.user_global_config(site)
      user_config(site).select { |attribute, _| GLOBAL_CONFIG.key? attribute }
    end

    def self.sources(site)
      assets(site).reduce(Set[]) { |sources, asset| sources.add asset.source }
    end
  end
end
