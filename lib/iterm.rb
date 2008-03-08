require 'session'
require 'appscript'

module Godo
  
  class ITermSession < Session
    
    def initialize( path )
      super( path )
      @@iterm ||= Appscript::app( 'iTerm' )
    end
      
    def create( label, command )
      start
      execute( "cd #{path}" )
      if label
        label = eval( "\"" + label + "\"" )      
        execute( "echo -n -e \"\\033]0;#{label}\\007\"; clear;" )
      else
        execute( "clear;" )
      end
      execute( command ) unless command.nil?
    end
    
    def start
      @session = @@iterm.current_terminal.sessions.end.make( :new => :session )
      @session.exec( :command => 'bash -l' )
    end
    
    def execute( command )
      @session.write( :text => command )
    end
    
  end
  
end
