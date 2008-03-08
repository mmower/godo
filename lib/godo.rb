require 'yaml'

require 'finder'
require 'project'

module Godo
  VERSION = '1.0.0'
  LIBPATH = File.expand_path( File.dirname( __FILE__ ) )
  
  def self.libpath( *args )
    args.empty? ? LIBPATH : File.join( LIBPATH, *args )
  end
  
  def self.install_config
    raise "Will not overwrite config. Please delete ~/.godo if you wish to update it." if File.exists?( File.expand_path( '~/.godo' ) )
    self.copy( libpath( 'template.yml' ), '~/.godo' )
  end
  
  def self.copy( from, path, overwrite = false )
    if File.exists?( path ) && !overwrite
      raise "Cannot overwrite #{path}. Please delete first and try again."
    else
      File.open( File.expand_path( path ), "w" ) do |file|
        file.write( File.read( from ) )
      end
    end
  end
  
  def self.invoke( query, options )
    Invoker.new( options ).invoke( query )
  end
  
  class Invoker
    
    def initialize( options )
      @options = options
      @config = YAML::load( File.read( File.expand_path( "~/.godo" ) ) )
    end
    
    def invoke( query )
      paths = Finder.find( query, @config )
      if paths.empty?
        puts "No match for: #{query}"
      else
        paths = strip_inexact_matches( query, paths )
        if paths.size > 1
          if base_match( paths )
            invoke_project( paths.first )
          else
            puts "Multiple ambgiuous matches for: #{query}"
            paths.each do |path|
              puts "\t#{path}"
            end
          end
        else
          invoke_project( paths.first )
        end
      end
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

    def invoke_project( path )
      project = Project.new( @options, @config )
      project.invoke( path )
    end
  end
  
end
