require "metafun/delegator"

require "fast/file"
require "fast/dir"

module Fast
  # Returns the list of entries in the directory
  # Options:
  # 
  #     `:extension => ".jpg"`         # Filters returned files by extension
  #     `:strip_extension => true`     # If an `:extension` is given, returns the
  #                                    # entries without it
  def self.dir path, options = nil
    if options
      if options[:extension]
        filtered = []
        Dir.entries(path).each do |entry|
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
      Dir.entries path
    end
  end
  
  # Like `dir`, but creates the directory if it does not exist
  def self.dir! path, options = nil
    mkdir path unless dir? path
    dir path, options
  end
  
  # Returns true if a directory named `path` exists, false otherwise.
  # (wrapper for `File.directory? <path>`)
  def self.dir? path  
    ::File.directory? path
  end
  
  # Returns an instance of Fast::File and passed all methods 
  # and arguments to it
  def self.file *args
    Fast::File.call *args
  end
  
  private
    def self.mkdir path
      path.split("/").each do |part|
        route ||= part
        Dir.mkdir route unless route == "" || ::File.directory?( route )
        route += "/#{path}"
      end
      # Dir.mkdir path # It seems this was redundant
    end
end

include Metafun::Delegator

delegate Fast, :dir, :dir?, :dir!, :file, :from
