module Godo
  
  class Project
    
    def self.find( query, options )
      project_root = File.expand_path( options["godo"]["projects"] )
      puts "Project root: #{project_root}"
      nil
    end
    
  end
  
end