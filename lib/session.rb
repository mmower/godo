module Godo
  
  class Session
    attr_reader :path
    
    def initialize( path )
      @path = path
      @counters = Hash.new { 0 }
    end
    
    def create( label, command, exit )
      start
      set_label( label )
      execute( "cd #{path}; clear;" )
      
      if command
        command = eval( "\"" + command + "\"", get_binding )
        execute( command )
      end
      
      if exit
        execute( "sleep 5; exit" )
      end
    end
    
    def set_label( label )
      if label
        label = eval( "\"" + label + "\"" )
        execute( "echo -n -e \"\\033]0;#{label}\\007\"; clear;" )
      else
        execute( "clear;" )
      end
    end
    
    def start
      raise "#{self.class.name} must implement #start"
    end
    
    def execute( command )
      raise "#{self.class.name} must implement #execute"
    end
    
    def counter( name )
      @counters[name] += 1
      "#{@counters[name]}"
    end
    
  private
    def get_binding( project_path = @path )
      binding
    end
    
  end
  
  # Load all Session subclasses in lib/sessions/*.rb
  Dir.glob( "#{libpath('sessions')}/*.rb" ) { |path| require path }
  
end
