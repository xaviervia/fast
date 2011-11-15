require "metafun/delegator"

require "fast/file"
require "fast/dir"
require "fast/dir-filter"
require "fast/file-filter"
require "fast/fast"

module Fast  
  # Like `dir`, but creates the directory if it does not exist
  def self.dir! path, options = nil
    Dir.new.create! path unless dir? path
    dir path, options
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
  
  def self.file! path
    File.new.touch path
  end
  
  # Returns an instance of Fast::File and passed all methods 
  # and arguments to it
  def self.file *args
    Fast::File.call *args
  end
end

include Metafun::Delegator

delegate Fast, :dir, :dir?, :dir!, :file, :file?, :file!
