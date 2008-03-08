module Godo
  
  class Project
    
    def initialize( options )
      @heuristics = options["heuristics"]
      @actions = options["actions"]
      @matchers = options["matchers"]
      
      require options["sessions"].downcase
      @session_class = Godo.const_get( "#{options[ "sessions" ]}Session" )
    end
    
    def invoke( path )
      matcher = find_match( path )
      if matcher
        invoke_actions( path, matcher["actions"] )
      else
        puts "No match project actions"
      end
    end
    
  private
    def invoke_actions( path, action_group )
      session = @session_class.new( path )
      action_group.each { |action|
        label = @actions[action]["label"]
        command = @actions[action]["command"]
        session.create( label, command )
      }
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