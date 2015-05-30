class Window
  
  attr_accessor :windowskin
  attr_accessor :contents
  attr_accessor :stretch
  attr_accessor :cursor_rect
  attr_accessor :active
  attr_accessor :pause
  attr_accessor :x
  attr_accessor :y
  attr_accessor :width
  attr_accessor :height
  attr_accessor :z
  attr_accessor :ox
  attr_accessor :oy
  attr_accessor :opacity
  attr_accessor :back_opacity
  attr_accessor :conents_opacity
  
  def initialize(viewport = nil)
    @windowskin = nil
    @contents = Bitmap.new(32,32)
    @stretch = false
    @cursor_rect = Rect.new(0,0,0,0)
    @active = true
    @pause = false
    @x = 0
    @y = 0
    @width = 0
    @height = 0
    @z = 0
    @ox = 0
    @oy = 0
    @opacity = 255
    @back_opacity = 255
    @contents_opacity = 255
   
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