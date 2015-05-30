class Plane
  
  attr_accessor :bitmap
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :zoom_x
  attr_accessor :zoom_y
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :color
  attr_accessor :tone
  
  def initialize(viewport = nil)
    @bitmap = nil
    @visible = true
    @z = 0
    @ox = 0
    @oy = 0
    @zoom_x = 1
    @zoom_y = 1
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
   
end