
class Script
  
    attr_reader :id
    attr_accessor :name
    attr_accessor :contents
   
    def initialize(id, name, contents)
        @id = id
        @name = name
        @contents = contents
    end
end