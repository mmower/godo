require 'yaml'

module Godo
  VERSION = '1.0.4'
  LIBPATH = File.expand_path( File.dirname( __FILE__ ) )
  
  # When called with no arguments this will return the path to the gem
  # library for godo. Any arguments are then appended to the library
  # path.
  def self.libpath( *args )
    args.empty? ? LIBPATH : File.join( LIBPATH, *args )
  end
  
  # This method copies the template configuration file from the gem
  # into the users home directory. It will raise an exception if the
  # user already has a config file.
  def self.install_config
    self.copy( libpath( 'template.yml' ), '~/.godo' )
  end

  # Copy a file handling overwrite protection.
  def self.copy( from, path, overwrite = false )
    path = File.expand_path( path )
    if File.exists?( path ) && !overwrite
      raise "Will not overwrite #{path}. Please delete first and try again."
    else
      File.open( File.expand_path( path ), "w" ) do |file|
        file.write( File.read( from ) )
      end
    end
  end
  
  # Given the query attempt to find a project path in any of the users configured
  # project roots that matches. If a clear match is made detect the type of
  # project and invoke the appropriate actions.
  def self.godo( query, options )
    config = YAML::load( File.read( File.expand_path( "~/.godo" ) ) )
    require 'finder'
    paths = Finder.find( query, config )
    found_path = if paths.empty?
      puts "No paths match for: #{query}"
    elsif paths.size > 1
      require 'highline/import'
      puts "Multiple, ambgiuous, paths match for: #{query}"
      puts "Please pick one of the following:"
      choose(*paths)
    else
      puts "Matching project: #{paths.first}"
      paths.first
    end
    
    if found_path
      require 'project'
      project = Project.new( options, config )
      project.invoke( found_path )
    end
  end
  
end
