require 'zlib'
require 'Pathname'
require_relative 'script.rb'

#==============================================================================================
# RGSS Base Class Project (RMXP, RMVX, RMVX2)
#==============================================================================================
class Project
    
    attr_reader :path
    attr_reader :scripts #TODO create a safe iterable list?
    
    private
    def initialize(path)
        @path = path
        
        file = File.open(@path, "rb")

        raw_data = Marshal.load(file.read.to_s).map! do |v|
            v[2] = Zlib.inflate v[2]; v
        end
        
        @scripts = []
        
        for script_data in raw_data
            script = Script.new(script_data[0], script_data[1], script_data[2])
            @scripts.push(script)
        end
        
        load_rpg_data
        
        file.close
    end
  
    
    def game_path
        return Pathname.new(path).parent.parent.to_s + "\\Game.exe"
    end
    
    public
    def self.create(path)
      case File.extname(path)
        when ".rxdata"
          return RMXP_Project.new(path)
        end
        
    end
    
    #-----------------------------------------------------------------------------------------------
    # Has valid game path?
    # => Return wether or not there is a valid game.exe executable file
    #-----------------------------------------------------------------------------------------------
    def has_valid_game_path?
        return File.exists?(game_path)
    end
    
    #-----------------------------------------------------------------------------------------------
    # Close project
    #-----------------------------------------------------------------------------------------------
    def close
        @scripts = []
    end
    
    #-----------------------------------------------------------------------------------------------
    # Save
    #-----------------------------------------------------------------------------------------------
    def save
      
        raw_data_list = []
      
        for script in @scripts
            raw_data = []
            raw_data.push(script.id)
            raw_data.push(script.name)
            raw_data.push(script.contents)
            raw_data_list.push(raw_data)
        end
      
        file = File.open(@path, "wb")
        file.write Marshal.dump raw_data_list.map {
            |v| [v[0], v[1], Zlib.deflate(v[2])]
        }
        file.close
    end
    
    def eval
        line_number = 0
        script_name = ""
        for script in @scripts#.reverse
          
          #line_number = 0
          #script.contents.each_line do |line|
          #  Kernel.eval(line, nil, script.name, line_number)
          #  line_number += 1
          #  p line_number
          #end
         
          script_name = script.name
          
          begin
            Kernel.eval(script.contents, binding, __FILE__, __LINE__)
          rescue  Exception => e  
            p script_name
            p e
            p line_number
          end
        end
          
    end
end


#==============================================================================================
# RGSS RMXP Project
#==============================================================================================
class RMXP_Project < Project
    def load_rpg_data
      require_relative '.\RPG\XP\Win32API.rb'
      require_relative '.\RPG\XP\Graphics.rb'
      require_relative '.\RPG\XP\Viewport.rb'
      require_relative '.\RPG\XP\Input.rb'
      require_relative '.\RPG\XP\Sprite.rb'
      require_relative '.\RPG\XP\Window.rb'
      require_relative '.\RPG\XP\RPG_Actor.rb'
      require_relative '.\RPG\XP\RPG_Animation.rb'
      require_relative '.\RPG\XP\RPG_Cache.rb'
      require_relative '.\RPG\XP\RPG_Sprite.rb'
    end
end