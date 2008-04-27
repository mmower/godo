module Godo
  
  class Session
    attr_reader :path
    
    def self.klass( name = nil )
      klass = if name
        Godo.const_get( name )
      else
        case ENV['TERM_PROGRAM']
        when "iTerm.app"
          Godo.const_get( "ITermSession" )
        when "Apple_Terminal"
          Godo.const_get( "TerminalSession" )
        end
      end
      
      raise "No session specified in config and cannot auto-detect from TERM_PROGRAM environment variable (#{ENV['TERM_PROGRAM'].inspect})." unless klass
      klass
    end
    
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
