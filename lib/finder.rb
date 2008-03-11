require 'find'

module Godo
  
  class Finder
    
    # Find, if possible, a single project path matching the query string.
    #
    def self.find( query, options )
      let( Finder.new( options["projects"], options["ignores"], options["max_depth"] ) ) do |finder|
        finder.find( Regexp.escape( query ) )
      end
    end
    
    # Create a Finder which will search under the given root folders, ignoring
    # folders that match any of the specified 'ignore' patterns.  Searches only
    # max_depth folders below the root paths, searches unlimited depth if not
    # specified.
    #
    def initialize( roots, ignores, max_depth = 0 )
      @roots = roots.map { |root| File.expand_path( root ) }
      @ignores = ignores.map { |ignore| Regexp.compile( "/#{ignore}" ) }
      @max_depth = max_depth.to_i
    end
    
    # Search for a folder matching the query.
    #
    # 1) If a single folder is found it is returned.
    #
    # 2) If multiple folders are found then an attempt is made to strip any folders
    # that are not an exact match for the query string.
    #
    # For example with the query 'reeplay' returning the following paths
    #
    # Paths:
    #   /root/reeplay.it
    #   /root/reeplay.it/reeplay
    #   /root/reeplay.it/reeplay/app
    #
    # The first path would be stripped because none of it's components are an exact
    # match for the query term.
    #
    # 3) If there are still multiple folders then the remaining folders are checked
    # to see if they contain the first folder as a base path. If so the first
    # path is returned.
    #
    # In this case because the second of the two remaining paths has the first as a
    # base path, the first path would be returned.
    #
    def find( query )
      matches = []
      @roots.each do |root|
        # puts "Searching for #{query} in #{root}"
        Find.find( root ) do |path|
          if @max_depth > 0
            # limit to @max_depth
            partial_path = path.gsub(root, '')
            Find.prune if partial_path =~ /\A\.+\Z/
            depth = partial_path.split('/').length
            Find.prune if depth > @max_depth + 1
          end

          if filtered?( path )
            Find.prune
          elsif matches?( path, query )
            matches << path
          end
        end
      end
      
      if matches.size > 1
        matches = strip_inexact_matches( query, matches )
        if matches.size > 1
          if base_match( matches )
            matches[0,1]
          else
            matches
          end
        else
          matches
        end
      else
        matches
      end
    end
    
    def matches?( path, query )
      path.match( query )
    end

    def filtered?( path )
      !File.directory?( path ) || excluded?( path )
    end

    def excluded?( path )
      ignore = !!@ignores.detect { |ignore| ignore.match( path ) }
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