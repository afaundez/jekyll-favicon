# Extend String with extnames utils
class String
  def svg?
    ['.svg'].include? File.extname self
  end

  def png?
    ['.png'].include? File.extname self
  end

  def ico?
    ['.ico'].include? File.extname self
  end
end
