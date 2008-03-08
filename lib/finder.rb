require 'find'

module Godo
  
  class Finder
    
    def self.find( query, options )
      finder = Finder.new( options["projects"], options["ignores"] )
      finder.find( Regexp.escape( query ) )
    end
    
    def initialize( roots, ignores )
      @roots = roots.map { |root| File.expand_path( root ) }
      @ignores = ignores.map { |ignore| Regexp.compile( "/#{ignore}" ) }
    end
    
    def find( query )
      matches = []
      @roots.each do |root|
        # puts "Searching for #{query} in #{root}"
        Find.find( root ) do |path|
          if filtered?( path )
            Find.prune
          elsif matches?( path, query )
            matches << path
          end
        end
      end
      
      # puts "Found: #{matches.inspect}"
      matches
    end
    
    def matches?( path, query )
      path.match( query )
    end

    def filtered?( path )
      !File.directory?( path ) || excluded?( path )
    end

    def excluded?( path )
      ignore = !!@ignores.detect { |ignore| ignore.match( path ) }
      #puts "Ignore: #{path.inspect} -> #{ignore.inspect}"
      ignore
    end
    
  end
  
end