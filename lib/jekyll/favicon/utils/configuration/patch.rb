# frozen_string_literal: true

module Jekyll
  module Favicon
    module Utils
      module Configuration
        # Favicon configuration patch logic
        module Patch
          def self.included(klass)
            klass.extend(ClassMethods)
          end

          # Patch configuration with the block provided
          module ClassMethods
            def patch(value_or_values, &block)
              patch_method = case value_or_values
                             when Array then :patch_array
                             when Hash then :patch_hash
                             when Symbol, String then :patch_value
                             else return value_or_values
                             end
              send patch_method, value_or_values, &block
            end

            private

            def patch_array(values, &block)
              values.collect { |value| patch value, &block }
            end

            def patch_hash(values, &block)
              values.transform_values { |value| patch value, &block }
            end

            def patch_value(value, &block)
              block.call patch_value_string_symbol(value)
            end

            # :reek:UtilityFunction
            def patch_value_string_symbol(value)
              value.to_s.start_with?(':') ? value[1..-1].to_sym : value
            end
          end
        end
      end
    end
  end
end
