
class Script
  
    attr_reader :id
    attr_reader :name
    attr_reader :contents  
   
    def initialize(id, name, contents)
        @id = id
        @name = name
        @contents = contents
    end
end