require 'zlib'
require 'Pathname'
require_relative 'script.rb'

#==============================================================================================
# RGSS Project (RMXP, RMVX, RMVX2)
#==============================================================================================
class Project
    
    attr_reader :path
    attr_reader :scripts #TODO create a safe iterable list?

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
        
        file.close
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
        file = File.open(@path, "wb")
        file.write Marshal.dump @data.map {
            |v| [v[0], v[1], Zlib.deflate(v[2])]
        }
        file.close
    end
    
    private
    def game_path
        return Pathname.new(path).parent.parent.to_s + "\\Game.exe"
    end
end