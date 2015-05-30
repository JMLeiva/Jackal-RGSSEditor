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
    @bitmap = nil
    @src_rect = Rect.new(0,0,24,24)
    @visible = true
    @x = 0
    @y = 0
    @z = 0
    @ox = 0
    @oy = 0
    @zoom_x = 1
    @zoom_y = 1
    @angle = 0
    @mirror = false
    @bush_depth = false
    @opacity = 255
    @blend_type = 0
    @color = Color.new(255,255,255)
    @tone = Tone.new(255,255,255)
    @viewport = viewport
    
    @disposed = false
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
    @disposed
  end
  
  def viewport
    @viewport
  end
    
  def flash(color, duration)
  end
  
  def update
  end
  
  
end