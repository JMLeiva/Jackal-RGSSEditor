module Graphics
  
  attr_accessor :frame_rate
  attr_accessor :frame_count
  
  @frame_rate = 60
  @frame_count = 0
  
  def self.update
    @frame_count += 1
  end
  
  def self.freeze
  end
  
  def self.transition(duration=0,filename='',vague=40)
  end
  
  def self.frame_reset
    @frame_count = 0
  end
  
end