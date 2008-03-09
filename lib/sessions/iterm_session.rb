require 'session'
require 'appscript'

module Godo
  
  class ITermSession < Session
    
    def initialize( path )
      super( path )
      @@iterm ||= Appscript::app( 'iTerm' )
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
