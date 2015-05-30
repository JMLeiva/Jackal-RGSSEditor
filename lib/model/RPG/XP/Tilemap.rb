class Tilemap
  
  attr_accessor :tileset
  attr_accessor :autotiles
  attr_accessor :map_data
  attr_accessor :flash_data
  attr_accessor :priorities
  attr_accessor :visible
  attr_accessor :ox
  attr_accessor :oy
  
  def initialize(viewport=nil)
    @tileset = Bitmap.new(32,32)
    @autotiles = []
    @map_data = Table.new(3,3,3)
    @flash_data = Table.new(3,3)
    @priorities = Table.new(3)
    @visible = true
    @ox = 0
    @oy = 0
  end
  
  def dispose
  end
  
  def disposed?
  end
  
  def viewport
  end
  
  def update
  end
end