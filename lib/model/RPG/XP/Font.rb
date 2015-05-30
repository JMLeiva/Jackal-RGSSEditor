class Font
  attr_accessor :name
  attr_accessor :size
  attr_accessor :bold
  attr_accessor :italic
  attr_accessor :color
  
  @@default_name = ''
  @@default_size = 12
  @@default_bold = false
  @@default_italic = false
  @@default_color = Color.new(255,255,255)
  
  def initialize(name='',size=0)
    @name = name
    @size = size
    @bold = false
    @italic = false
    @color = Color.new(255,255,255)
  end
  
  def self.exists?(name)
    true
  end
  
  def self.default_name
    @@default_name
  end
  
  def self.default_name=(default_name)
    @@default_name = default_name
  end
  
  def self.default_size
    @@default_size
  end
  
  def self.default_size=(default_size)
    @@default_size = default_size
  end
  
  def self.default_bold
    @@default_bold
  end
  
  def self.default_bold=(default_bold)
    @@default_bold = default_bold
  end
  
  def self.default_italic
    @@default_italic
  end
  
  def self.default_italic=(default_italic)
    @@default_italic = default_italic
  end
  
  def self.default_color
    @@default_color
  end
  
  def self.default_color=(default_color)
    @@default_color = default_color
  end
end