class Viewport
  
  attr_accessor :rect
  attr_accessor :visible
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :color
  attr_accessor :tone
  
  def initialize(x, y, width, height)
    rect = Rect.new(x,y, width, height)
    initialize(rect)
  end
  
  def intialize(rect)
    @rect = rect
    @visible = true
    @z = 0
    @ox = 0
    @oy = 0
    @color = Color.new(255,255,255)
    @tone = Tone.new(255,255,255)
  
    @disposed = false
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
  end
  
  def flash(color, duration)
  end
  
  def update
  end
  
end