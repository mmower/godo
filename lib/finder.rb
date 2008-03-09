require 'find'

module Godo
  
  class Finder
    
    def self.find( query, options )
      finder = Finder.new( options["projects"], options["ignores"] )
      paths = finder.find( Regexp.escape( query ) )
      
      if paths.size > 1
        paths = strip_inexact_matches( query, paths )
        if paths.size > 1
          if base_match( paths )
            paths[0,1]
          end
        end
      end
      
      paths
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
    
    def strip_inexact_matches( query, paths )
      # If any of the paths have the query as a complete path component
      # then strip any paths that don't
      if paths.any? { |path| path.split( File::SEPARATOR ).any? { |component| query == component } }
        paths.select { |path| path.split( File::SEPARATOR ).any? { |component| query == component } }
      else
        paths
      end
    end
    
    def base_match( paths )
      # Is the first path a prefix for all subsequent-paths
      path_match = Regexp.compile( "^#{paths.first}" )
      paths[1..-1].all? { |path| path.match( path_match ) }
    end
    
  end
  
end