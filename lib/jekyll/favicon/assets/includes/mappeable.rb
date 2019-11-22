module Jekyll
  module Favicon
    # Mappeable options for Asset
    module Mappeable
      # MAPPINGS = {}.freeze

      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      # Add mappeable?
      module InstanceMethods
        def mappeable?
          self.class::MAPPINGS[source_extname].include?(extname)
        end
      end

      # Add maps?
      module ClassMethods
        def maps?(extname)
          self::MAPPINGS.values.flatten.include? extname
        end
      end
    end
  end
end
