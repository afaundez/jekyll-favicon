# Extend Hash with deep find of a key return array
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
end
