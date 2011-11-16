module Fast
  # Returns a Dir with the file list already called (if a path is provided)
  def self.dir path = nil
    Dir.new.list path if path
    Dir.new
  end
  
  # Like `dir`, but creates the directory if it does not exist
  def self.dir! path
    Dir.new.create( path ).list
  end
  
  # Returns a File with its content (if a path to a valid file is provided)
  def self.file path = nil
    File.new.read path if path
    File.new
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
