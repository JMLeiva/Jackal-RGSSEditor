class Rect

  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  
  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
  
  def set(x, y, width, height)
    @x = x
    @y = y
    @width = width
    @height = height
  end
  
end