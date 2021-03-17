# frozen_string_literal: true

# Extend Array with deep methods
class Array
  def deep_compact
    each_with_object([]) do |value, memo|
      if (value.is_a?(Array) || value.is_a?(Hash)) && !value.empty?
        memo << value.deep_compact
      elsif !value.nil?
        memo << value
      end
    end
  end
end
