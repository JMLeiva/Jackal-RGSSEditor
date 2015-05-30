def load_data(filename)
  if filename.include?('Actors.rxdata')
    return []
  end
  
  if filename.include?('Classes.rxdata')
    return []
  end
  
  if filename.include?('Skills.rxdata')
    return []
  end
  
  if filename.include?('Items.rxdata')
    return []
  end
  
  if filename.include?('Weapons.rxdata')
    return []
  end
  
  if filename.include?('Armors.rxdata')
    return []
  end
  
  if filename.include?('Troops.rxdata')
    return []
  end
  
  if filename.include?('States.rxdata')
    return []
  end
  
  if filename.include?('Animations.rxdata')
    return []
  end
  
  if filename.include?('Tilesets.rxdata')
    return []
  end
  
  if filename.include?('CommonEvents.rxdata')
    return []
  end
    
  if filename.include?('System.rxdata')
    return RPG::System.new
  end
end

def save_data(obj, filename)
end


