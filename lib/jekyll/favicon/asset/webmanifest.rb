# Build Webmanifest JSON
class Jekyll::Favicon::Asset::Webmanifest
  attr_accessor :document

  def load(source_path, config, prefix)
    @document = if File.exist? source_path
                  JSON.parse File.read source_path
                else
                  {}
                end
    add_webmanifest_elements config, prefix
  end

  def dump
    JSON.pretty_generate document
  end

  private

  def add_webmanifest_elements(config, prefix)
    icons = config['sizes'].collect do |size|
      {
        src: File.join(prefix, "favicon-#{size}.png"),
        type: 'png',
        sizes: size
      }
    end
    @document = Jekyll::Utils.deep_merge_hashes @document, icons: icons
  end
end
