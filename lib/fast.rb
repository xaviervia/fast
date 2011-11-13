require "metafun/delegator"

require "fast/file"
require "fast/dir"
require "fast/dir-filter"
require "fast/file-filter"

module Fast
  # Returns the list of entries in the directory
  # Options:
  # 
  #     `:extension => ".jpg"`         # Filters returned files by extension
  #     `:strip_extension => true`     # If an `:extension` is given, returns the
  #                                    # entries without it
  def self.dir path, options = nil
    current = Dir.new path
    if options
      if options[:extension]
        filtered = []
        current.list path do |entry|
          if entry.end_with? ".#{options[:extension]}"
            if options[:strip_extension]
              filtered << entry[0..-("#{options[:extension]}".length)-2]
            else
              filtered << entry 
            end
          end
        end
        return filtered
      end
    else
      current.list path
    end
  end
  
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
  
  # Returns an instance of Fast::File and passed all methods 
  # and arguments to it
  def self.file *args
    Fast::File.call *args
  end
end

include Metafun::Delegator

delegate Fast, :dir, :dir?, :dir!, :file, :file?
