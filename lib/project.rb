require 'session'

module Godo
  
  class Project
    
    def initialize( options, config )
      @options = options
      @heuristics = config["heuristics"]
      @actions = config["actions"]
      @matchers = config["matchers"]
      @session_class = Godo.const_get( config["sessions"] )
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
      
      action_group.each do |action_item|
        action = case action_item
        when String
          @actions[action_item]
        when Hash
          action_item['label'] ||= action_item['command']
          action_item
        else
          puts "\tUnknown action type: #{action_item}"
        end
        
        if action
          exit = case action["exit"]
          when true
            true
          when "true"
            true
          when "1"
            true
          when "y"
            true
          else
            false
          end
        
          puts "\trunning: #{action["label"]} (exit: #{exit})"
          session.create( action["label"], action["command"], exit )
        else
          puts "\tMissing action: #{action_item.inspect}"
        end
      end
    end
  
    def find_match( path )
      if @options[:override]
        puts @options[:override]
        @matchers.find { |matcher| matcher["name"] == @options[:override] }
      elsif File.file?( project_level_godo = File.join(path, '.godo' ) )
        YAML::load( File.read( project_level_godo ) )
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