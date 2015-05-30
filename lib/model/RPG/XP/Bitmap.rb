class Bitmap
  
  attr_accessor :font
  
  def initialize(filename)
    @font = Font.new
    @disposed = false
    @rect = Rect.new(0,0,0,0)
  end
  
  def initialize(width, height)
    @font = Font.new
    @disposed = false
    @rect = Rect.new(0,0,width,height)
  end
  
  def dispose
    @disposed = true
  end
  
  def disposed?
    @disposed
  end
  
  def width
    @rect.width
  end
  
  def height
    @rect.height
  end
  
  def rect
    @rect
  end
  
  def blt(x, y, src_bitmap, src_rect, opacity=0)
  end
  
  def stretch_blt(dest_rect, src_bitmap, src_rect, opacity=0)
  end
  
  def fill_rect(x,y, width, height, color)
  end
  
  def fill_rect(rect, color)
  end
  
  def clear
  end
  
  def get_pixel(x, y)
    Color.new(0,0,0,0)
  end
  
  def set_pixel(x, y, color)
  end
  
  def hue_change(hue)
  end
  
  def draw_text(x, y, width, height, str, align=0)
  end
  
  def draw_text(rect, str, align=0)
  end
  
  def text_size(str)
    Rect.new(0,0,10,10)
  end
end