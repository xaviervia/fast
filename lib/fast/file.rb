module Fast
  # File handling class.
  class File
    # Appends the passed content to the file `path`
    def append path, content
      ::File.open path, "a" do |handler|
        handler.write content
      end
    end
    
    # Deletes the file (wrapper for `File.unlink <path>`)
    def delete path
      ::File.unlink path
    end
  
    alias :destroy :delete
    alias :unlink :delete
    alias :del :delete
    
    def self.call *args
      if args.empty?
        File.new
      else
        ::File.read args.shift
      end
    end
  end
end
