module Fast
  # File handling class.
  class File
    # Appends the passed content to the file `path`
    # Creates the file if it doesn't exist.
    # Creates all the necesary folders if they don't exist
    def append path, content
      @path = normalize path
      Fast.dir! ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "a" do |handler|
        handler.write content
      end
      @path
    end
    
    # Deletes the file (wrapper for `File.unlink <path>`)
    def delete path
      @path = normalize path
      ::File.unlink @path
      @path
    end
  
    alias :destroy :delete
    alias :unlink :delete
    alias :del :delete
    
    # Touches the file passed. Like bash `touch`, but creates
    # all required directories if they don't exist
    def touch path
      @path = normalize path
      Fast::Dir.new.create ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "a+" do |file|
        file.gets; file.write ""
      end
      @path
    end
    
    # Returns the contents of the file, all at once
    def read path
      @path = normalize path
      ::File.read @path
    end
    
    def self.call *args
      if args.empty?
        File.new
      else
        ::File.read args.shift
      end
    end
    
    private
      def normalize path
        "#{path}"
      end
  end
end
