module Godo
  
  class Project
    
    def initialize( options, config )
      @options = options
      @heuristics = config["heuristics"]
      @actions = config["actions"]
      @matchers = config["matchers"]
      
      require config["sessions"].downcase
      @session_class = Godo.const_get( "#{config[ "sessions" ]}Session" )
    end
    
    def invoke( path )
      matcher = find_match( path )
      if matcher
        puts "Project type: #{matcher["name"]}"
        invoke_actions( path, matcher["actions"] )
      else
        puts "No matching project type"
      end
    end
    
  private
    def invoke_actions( path, action_group )
      session = @session_class.new( path )
      
      missing_actions = action_group.find_all { |action| !@actions.has_key?( action ) }
      if missing_actions.empty?
        action_group.each { |action|
          puts "\trunning: #{action}"
          label = @actions[action]["label"]
          command = @actions[action]["command"]
          session.create( label, command )
        }
      else
        missing_actions.each do |action|
          puts "\tMissing action: #{action}"
        end
      end
    end
  
    def find_match( path )
      if @options[:override]
        puts @options[:override]
        @matchers.find { |matcher| matcher["name"] == @options[:override] }
      else
        @matchers.detect { |matcher|
          matcher["heuristics"].all? { |heuristic|
            satisfies?( path, heuristic )
          }
        }
      end
    end
  
    def satisfies?( path, heuristic )
      eval( @heuristics[heuristic], get_binding( path ) )
    end
    
    def get_binding( project_path )
      binding
    end
    
  end
  
end