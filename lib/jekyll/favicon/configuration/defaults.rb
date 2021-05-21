# frozen_string_literal: true

require 'jekyll/favicon/utils'
require 'jekyll/favicon/configuration'

module Jekyll
  module Favicon
    module Configuration
      # Create configurable for include
      module Defaults
        def self.included(base)
          *modules, class_or_module_name = base_name_to_parts base.name
          method_name = "#{class_or_module_name}_defaults"
          define_defaults base, method_name do
            Favicon::Configuration.load_defaults(*modules, class_or_module_name)
          end
        end

        def self.define_defaults(base, method_name, &block)
          base.define_singleton_method('defaults', &block)
          define_method(method_name, &block)
        end

        def self.base_name_to_parts(name)
          name.split('::').collect do |module_or_class|
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
