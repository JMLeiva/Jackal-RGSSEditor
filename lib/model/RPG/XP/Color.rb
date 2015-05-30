class Color
  
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :alpha
  
  def initialize(red, green, blue, alpha=0)
    @red = red
    @green = green
    @blue = blue
    @alpha = alpha
  end
  
  def set(red, green, blue, alpha=0)
    @red = red
    @green = green
    @blue = blue
    @alpha = alpha
  end  
end