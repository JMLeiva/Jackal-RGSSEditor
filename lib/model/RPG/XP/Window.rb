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
  end
  
  def dispose
  end
  
  def disposed?
  end
  
  def viewport
  end
  
end