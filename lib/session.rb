module Godo
  
  class Session
    attr_reader :path
    
    def initialize( path )
      @path = path
      @counters = Hash.new { 0 }
    end
    
    def create( label, command )
      raise "Session subclasses must define #create!"
    end
    
    def counter( name )
      @counters[name] += 1
      "#{@counters[name]}"
    end
    
  end
  
end
