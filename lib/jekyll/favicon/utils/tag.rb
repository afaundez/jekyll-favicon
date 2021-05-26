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

        # Favicon rexml utils functions
        module ClassMethods
          # :reek:FeatureEnvy
          def mutate_element(parent, changes = {})
            changes.each_with_object(parent) do |(key, value), memo|
              if key.start_with? '__' then memo.text = value
              elsif key.start_with? '_' then memo.add_attribute key[1..-1], value
              else mutate_element mutate_find_or_create_element(memo, key), value
              end
            end
          end

          def build_element(name, parent = nil, config = {})
            element = REXML::Element.new name, parent
            return populate_element element, config if config.is_a? Enumerable

            element.text = config and return element
          end

          private

          # :reek:UtilityFunction
          def mutate_find_or_create_element(parent, key)
            parent.get_elements(key).first || parent.add_element(key)
          end

          # :reek:FeatureEnvy
          def populate_element(element, config)
            config.each_with_object(element) do |(key, value), memo|
              if key.start_with? '__' then memo.text = value
              elsif (child_key = key.match(/^_(.*)$/))
                memo.add_attribute child_key[1], value
              else build_element key, memo, value
              end
            end
          end
        end
      end
    end
  end
end
