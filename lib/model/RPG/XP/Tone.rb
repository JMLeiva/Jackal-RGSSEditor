class Tone
  attr_accessor :red
  attr_accessor :green
  attr_accessor :blue
  attr_accessor :gray
  
  def initialize(red, green, blue, gray=0)
    @red = red
    @green = green
    @blue = blue
    @gray = gray
  end
  
  def set(red, green, blue, gray=0)
    @red = red
    @green = green
    @blue = blue
    @gray = gray
  end
end