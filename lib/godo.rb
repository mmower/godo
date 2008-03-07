class Godo
  VERSION = '1.0.0'
  LIBPATH = File.expand_path( File.dirname( __FILE__ ) )
  
  def self.libpath( *args )
    args.empty? ? LIBPATH : File.join( LIBPATH, *args )
  end
  
  def self.install_config
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
    
  end
end
