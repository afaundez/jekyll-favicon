def build_site_config(overrides = {})
  defaults = { 'baseurl' => '', 'url' => '' }
  Jekyll::Favicon::Utils.merge(defaults, overrides).to_yaml
end

def build_site_favicon(overrides = { 'svg' => {} })
  defaults = { 'svg' => { '_viewBox' => '0 0 32 32', '_xmlns' => 'http://www.w3.org/2000/svg', 'circle' => { '_cx' => 16, '_cy' => 16, '_r' => 14, '_fill' => 'red' } } }
  Jekyll::Favicon::Utils.build_element 'svg', nil, Jekyll::Favicon::Utils.merge(defaults['svg'], overrides['svg'])
end

def build_site_browserconfig(overrides = { 'browserconfig' => {} })
  document = REXML::Document.new
  document << REXML::XMLDecl.new('1.0', 'UTF-8')
  defaults = { 'browserconfig' => { 'msapplication' => { 'notification' => { 'frequency' => 30 } } } }
  Jekyll::Favicon::Utils.build_element 'browserconfig', document, Jekyll::Favicon::Utils.merge(defaults['browserconfig'], overrides['browserconfig'])
  document
end

def build_site_webmanifest(overrides = {})
  defaults = { 'name' => 'Jekyll Favicon' }
  Jekyll::Favicon::Utils.merge defaults, overrides
end

def build_site_index
  "---\n---\n<html><head>{% favicon %}</head></html>\n"
end

def empty
  {}
end

def red_favicon
  { 'svg' => { '_viewBox' => '0 0 32 32', '_xmlns' => 'http://www.w3.org/2000/svg',
               'circle' => { '_cx' => 16, '_cy' => 16, '_r' => 14, '_fill' => 'red' } } }
end

blue_favicon = Marshal.load Marshal.dump(red_favicon)
blue_favicon['svg']['circle']['_fill'] = 'blue'

def conventioned
  { favicon: { name: 'favicon.svg', options: red_favicon }, index: {} }
end

def configured_webmanifest
  { 'name' => 'Jekyll Favicon' }.to_json
end

def configured_browserconfig
  { 'browserconfig' => { 'msapplication' => { 'notification' => { 'frequency' => 30 } } } }
end

def configured_site
  {
    'baseurl' => 'blog',
    'url' => 'http://example.com',
    'favicon' => {
      'source' => 'images/custom-source.svg',
      'background' => 'black',
      'dir' => 'assets',
      'assets' => [
        { 'name' => 'assets/configured-favicon-128x128.png',
          'source' => 'images/custom-source.svg',
          'tag' => [{ 'link' => { 'href' => :url, 'crossorigin' => 'use-credentials' } }, { 'meta' => { 'name' => :name } }],
          'refer' => [{ 'webmanifest' => { 'icons' => { 'scr' => :url}}}, { 'browserconfig' => { 'msapplication' => { 'configured' => { '__text' => :url}}}}]
        },
        { 'name' => 'assets/configured-browserconfig.xml', 'source' => 'data/source.xml' },
        { 'name' => 'assets/configured-manifest.webmanifest', 'source' => 'data/source.json', 'tag' => [{ 'link' => { 'href' => :href,  'crossorigin' => 'use-credentials' } }] }
      ]
    }
  }
end

def configured
  {
    site: configured_site,
    index: {},
    favicon: { name: 'images/custom-source.svg', options: red_favicon },
    browserconfig: { name: 'data/source.xml', options: configured_browserconfig },
    webmanifest: { name: 'data/source.json', options: configured_webmanifest }
  }
end

module Fixtures
  module Source
    def self.build(path, options = {})
      File.write File.join(path, '_config.yml'), build_site_config(options[:site]) if options[:site] 
      File.write File.join(path, 'index.html'), build_site_index if options[:index]

      if options[:favicon]
        dir, name = File.split File.join(path, options[:favicon][:name])
          FileUtils.mkdir_p dir
        if File.extname(name) == '.svg'
          File.write File.join(dir, name), build_site_favicon(options[:favicon][:options])
        elsif File.extname(name) == '.png'
          FileUtils.cp File.join(File.dirname(__FILE__), 'favicon.png'), File.join(dir, name)

        end
      end

      if options[:browserconfig]
        dir, name = File.split File.join(path, options[:browserconfig][:name])
        FileUtils.mkdir_p dir
        File.write File.join(dir, name), build_site_browserconfig(options[:browserconfig][:options])
      end

      if options[:webmanifest]
        dir, name = File.split File.join(path, options[:webmanifest][:name])
        FileUtils.mkdir_p dir
        File.write File.join(dir, name), build_site_webmanifest(options[:webmanifest][:options])
      end
    end
  end
end
