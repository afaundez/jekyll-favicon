# frozen_string_literal: true

# Extend Hash with deep methods
class Hash
  def deep_find(target)
    keys.collect do |key|
      if key == target
        self[key]
      elsif self[key].is_a? Hash
        self[key].deep_find(target)
      end
    end.compact.flatten
  end

  def deep_compact
    each_with_object({}) do |(key, value), memo|
      if (value.is_a?(Array) || value.is_a?(Hash)) && !value.empty?
        memo[key] = value.deep_compact
      elsif !value.nil?
        memo[key] = value
      end
    end
  end
end
