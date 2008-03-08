require 'session'
require 'appscript'

module Godo
  
  class ITermSession < Session
    
    def initialize( path )
      super( path )
      @iterm = Appscript::app( 'iTerm' )
    end
      
    def create( label, command )
      label = eval( "\"" + label + "\"" )
      session = @iterm.current_terminal.sessions.end.make( :new => :session )
      session.exec( :command => 'bash -l' )
      session.write( :text => "cd #{path}" )
      session.write( :text => "echo -n -e \"\\033]0;#{label}\\007\"; clear;" )
      session.write( :text => command ) unless command.nil?
    end
    
  end
  
end
