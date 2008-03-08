module Godo
  
  class Project
    
    def initialize( options )
      @heuristics = options["heuristics"]
      @actions = options["actions"]
      @matchers = options["matchers"]
    end
    
    def invoke( path )
      matcher = find_match( path )
      if matcher
        invoke_actions( matcher["actions"])
      else
        puts "No match project actions"
      end
    end
    
  private
    def invoke_actions( actions )
      actions.each do |action|
        puts ":#{action}"
      end
    end
  
    def find_match( path )
      @matchers.detect { |matcher|
        matcher["heuristics"].all? { |heuristic|
          satisfies?( path, heuristic )
        }
      }
    end
  
    def satisfies?( path, heuristic )
      eval( @heuristics[heuristic], get_binding( path ) )
    end
    
    def get_binding( project_path )
      binding
    end
    
  end
  
end