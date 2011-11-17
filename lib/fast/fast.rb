module Fast
  # Returns a Dir with the file list already called (if a path is provided)
  def self.dir path = nil
    unless path.nil?
      the_dir = Fast::Dir.new path
      the_dir.list
    else 
      Fast::Dir.new
    end
  end
  
  # Like `dir`, but creates the directory if it does not exist
  def self.dir! path
    Dir.new.create( path ).list
  end
  
  # Returns a File with its content (if a path to a valid file is provided)
  def self.file path = nil
    if path
      the_file = Fast::File.new path 
      the_file.read
    else 
      Fast::File.new
    end
  end
  
  # Returns a File, and creates it if is does not exist
  def self.file! path
    File.new.create path
  end
  
  # Returns true if a directory named `path` exists, false otherwise.
  # (wrapper for `File.directory? <path>`)
  def self.dir? path  
    Dir.new.exist? path
  end
  
  # Example. This all will be deprecated when features are done
  def self.file? path
    File.new.exist? path
  end
end
