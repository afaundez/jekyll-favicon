require 'rexml/document'

# Build browserconfig XML
class Browserconfig
  attr_accessor :document

  def load(source_path, config, prefix)
    @document = if File.exist? source_path
                  REXML::Document.new File.read source_path
                else
                  REXML::Document.new
                end
    add_browserconfig_schema
    add_browserconfig_elements config, prefix
  end

  def add(path, element, attributes = {}, text = nil)
    parent = @document.elements[path]
    parent.elements[element] = REXML::Element.new element
    attributes.each do |key, value|
      parent.elements[element].add_attribute key, value
    end
    parent.add_text text if text
  end

  def dump
    output = ''
    formatter = REXML::Formatters::Pretty.new 2
    formatter.compact = true
    formatter.write @document, output
    output
  end

  private

  def add_browserconfig_schema
    browserconfig = @document.elements['browserconfig']
    browserconfig ||= @document.elements.add 'browserconfig'
    msapplication = browserconfig.elements['msapplication']
    msapplication ||= browserconfig.elements.add 'msapplication'
    tile = msapplication.elements['tile']
    tile || msapplication.elements.add('tile')
  end

  def add_browserconfig_elements(config, prefix)
    path = 'browserconfig/msapplication/tile'
    pathname = Pathname.new prefix
    add path, 'square70x70logo', 'src' => pathname.join('favicon-128x128.png')
    add path, 'square150x150logo', 'src' => pathname.join('favicon-270x270.png')
    add path, 'wide310x150logo', 'src' => pathname.join('favicon-558x270.png')
    add path, 'square310x310logo', 'src' => pathname.join('favicon-558x558.png')
    add path, 'TileColor', {}, config['tile-color']
  end
end
