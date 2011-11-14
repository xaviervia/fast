module Fast
  # File handling class.
  class File < String
  
    # Initializes the file
    def initialize source = nil
      unless source.nil?
        super( "#{source}" )
        @path = normalize source 
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
      self
    end
    
    # Writes data into the file. If is does not exist, creates it
    # if it already exists, overwrites it!
    def write *args
      if args.length > 1
        path, content = *args
        @path = normalize path
      else
        content = args.first
      end
      Fast.dir! ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "w" do |handler|
        handler.write content
      end
      self
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
    def read path = nil
      @path = normalize path if path
      ::File.read @path
    end

    # Returns true if file exists, false otherwise
    def exist? path
      @path = normalize path if path
      ::File.exist? @path
    end
    
    alias :exists? :exist?
    alias :exist_all? :exist?
    alias :exist_any? :exist?
    
    # Sends self to a FileFilter filter
    def filter
      FileFilter.new self
    end
    
    alias :by :filter
    
    # Expands the path if it's a relative path
    def expand path = nil
      @path = normalize path if path
      ::File.expand_path @path
    end
    
    alias :absolute :expand
        
    # Renames the file (by Fast::File own means, it does not call 
    # the underlying OS). Fails if the new path is an existent file
    def rename *args
      if args.length > 1
        path, new_path = *args
        @path = normalize path
        new_path = normalize new_path
      else
        new_path = normalize args.first
      end
      raise ArgumentError, "The file '#{new_path}' already exists" if File.new.exists? new_path
      renamed = File.new.write new_path, self.read
      self.delete!
      return renamed      
    end

    # Like #rename, but overwrites the new file if is exist
    def rename! *args
      if args.length > 1
        path, new_path = *args
        @path = normalize path
        new_path = normalize new_path
      else
        new_path = normalize args.first
      end
      renamed = File.new.write new_path, self.read
      self.delete!
      return renamed      
    end
    
    # Returns the path to the current file
    def path
      @path if @path
    end
    
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
