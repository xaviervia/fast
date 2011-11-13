module Fast
  # File handling class.
  class File < String
  
    # Initializes the file
    def initialize source = nil
      unless source.nil?
        super( "#{source}" ) 
      else
        super()
      end
    end
    
    # Appends the passed content to the file `path`
    # Creates the file if it doesn't exist.
    # Creates all the necesary folders if they don't exist
    def append *args
      if args.length > 1
        path, content = *args 
        @path = normalize path
      else
        content = args.first
      end
      Fast.dir! ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "a" do |handler|
        handler.write content
      end
      @path
    end
    
    # Deletes the file (wrapper for `File.unlink <path>`)
    def delete path = nil
      @path = normalize path if path
      ::File.unlink @path
      @path
    end
  
    alias :destroy :delete
    alias :unlink :delete
    alias :del :delete
    alias :delete! :delete
    
    # Touches the file passed. Like bash `touch`, but creates
    # all required directories if they don't exist
    def touch path
      @path = normalize path if path
      Fast::Dir.new.create ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "a+" do |file|
        file.gets; file.write ""
      end
      @path
    end
    
    alias :create :touch
    alias :create! :touch
    
    # Returns the contents of the file, all at once
    def read path
      @path = normalize path if path
      ::File.read @path
    end

    # Returns true if file exists, false otherwise
    def exist? path
      @path = normalize path if path
      ::File.exist? @path
    end
    
    alias :exists? :exist?
    
    # Sends self to a FileFilter filter
    def filter
      FileFilter.new self
    end
    
    alias :by :filter
        
    private
      def normalize path
        "#{path}"
      end
    
    # Deprecated!
    def self.call *args
      if args.empty?
        File.new
      else
        ::File.read args.shift
      end
    end
  end
end
