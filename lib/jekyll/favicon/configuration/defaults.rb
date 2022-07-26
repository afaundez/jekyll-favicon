# frozen_string_literal: true

require "yaml"

module Jekyll
  module Favicon
    ROOT = Pathname.new File.dirname(File.dirname(File.dirname(File.dirname(__dir__))))

    module Configuration
      # Create configurable for include
      module Defaults
        def self.included(base)
          *modules, class_or_module_name = base_name_to_parts base.name
          method_name = "#{class_or_module_name}_defaults"
          define_defaults base, method_name do
            Defaults.load_defaults(*modules, class_or_module_name)
          end
        end

        def self.load_defaults(*parts)
          load_file "config", *parts
        end

        def self.load_file(*parts)
          path = Favicon::ROOT.join(*parts).to_s
          path = "#{path}.yml"
          # Handle Psych 3 and 4
          begin
            YAML.load_file path, aliases: true
          rescue ArgumentError
            YAML.load_file path
          end
        end

        def self.define_defaults(base, method_name, &block)
          base.define_singleton_method("defaults", &block)
          define_method(method_name, &block)
        end

        def self.base_name_to_parts(name)
          name.split("::").collect do |module_or_class|
            camelcase_to_snakecase module_or_class
          end
        end

        def self.camelcase_to_snakecase(camelcase)
          camelcase.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
        end
      end
    end
  end
end
