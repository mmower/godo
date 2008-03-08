module Godo
  
  class Session
    attr_reader :path
    
    def initialize( path )
      @path = path
      @counters = Hash.new { 0 }
    end
    
    def create( label, command )
      start
      set_label( label )
      execute( "cd #{path}; clear;" )
      execute( command ) unless command.nil?
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
    
  end
  
end
