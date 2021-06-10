# frozen_string_literal: true

require 'rexml/document'

module Jekyll
  module Favicon
    module Utils
      # Favicon rexml for include
      module Tag
        def self.included(klass)
          klass.extend(ClassMethods)
        end

        def self.mutate_find_or_create_element(parent, key)
          parent.get_elements(key).first || parent.add_element(key)
        end

        def self.mutate_xml(parent, changes = {})
          changes.each_with_object(parent) do |(key, value), memo|
            mutate_iterator key, value, memo
          end
        end

        def self.mutate_iterator(key, value, memo)
          if key.start_with? '__' then memo.text = value
          elsif key.start_with? '_' then memo.add_attribute key[1..-1], value
          else Tag.mutate_xml Tag.mutate_find_or_create_element(memo, key), value
          end
        end

        def self.build_xml(name, parent = nil, config = {})
          element = REXML::Element.new name, parent
          return Tag.populate_element element, config if config.is_a? Enumerable

          element.text = config and return element
        end

        def self.populate_element(element, config)
          config.each_with_object(element) do |(key, value), memo|
            populate_iterator key, value, memo
          end
        end

        def self.populate_iterator(key, value, memo)
          if key.start_with? '__' then memo.text = value
          elsif (child_key = key.match(/^_(.*)$/))
            memo.add_attribute child_key[1], value
          else build_xml key, memo, value
          end
        end

        # Favicon rexml utils functions
        module ClassMethods
          def mutate_element(parent, changes = {})
            Tag.mutate_xml parent, changes
          end

          def build_element(name, parent = nil, config = {})
            Tag.build_xml name, parent, config
          end

          def build_tag(name, attributes = {})
            config = attributes.transform_keys { |key| "_#{key}" }
            Tag.build_xml name, nil, config
          end
        end
      end
    end
  end
end
