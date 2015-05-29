class Sprite
  
  attr_accessor :bitmap
  attr_accessor :src_rect
  attr_accessor :visible
  attr_accessor :x
  attr_accessor :y
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :angle
  attr_accessor :mirror
  attr_accessor :bush_depth
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
  
  def initialize(viewport = nil)
  end
  
  def dispose
  end
  
  def disposed?
  end
  
  def viewport
  end
  
  def flash(color, duration)
  end
  
  def update
  end
  
  
end