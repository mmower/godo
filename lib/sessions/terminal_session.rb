require 'session'
require 'appscript'

module Godo
  
  class TerminalSession < Session
    
    def initialize( path )
      super( path )
      @@terminal ||= Appscript::app('Terminal')
      @window = nil
    end
    
    def start
      if @window
        @window.frontmost.set(true)
        Appscript::app("System Events").application_processes["Terminal.app"].keystroke("t", :using => :command_down)
        while (@window.tabs.last.busy.get)
          # we're not on the new tab yet.  wait a bit...
          sleep 0.1
        end
      else
        first_tab = @@terminal.do_script('')
        @window = eval('Appscript::' + first_tab.to_s.gsub(/\.tabs.*$/, '')) # nasty hack.  is there a legit way to find my mommy?
      end
    end
    
    def execute( command )
      @@terminal.do_script(command, :in => @window.tabs.last.get)
    end
    
  end
  
end
