require "sub-setter/fast/file"  # This call should be automated in the sub-setter API somehow

module Fast
  # File handling class.
  #
  # Inherits from String in order to be usable as a String
  # Includes the module Fast::FilesystemObject for common
  # functionality with Fast::Dir
  class File < String
    include FilesystemObject
  
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
      
      do_append content
    end
    
    # Appends the passed content to the file
    # Creates the file if it doesn't exist.
    # Creates all the necesary folders if they don't exist
    # Fails if file path is not defined
    def << content
      raise "No path specified in the file" unless @path
      do_append content
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
      Fast::Dir.new.create! ::File.dirname @path if ::File.dirname(@path) != "."
      ::File.open @path, "w" do |handler|
        handler.write content
      end
      self
    end
    
    # Deletes the files (wrapper for `File.unlink <path>`)
    # Fails if file does not exist
    def delete *args
      unless args.empty?
        return_me = nil
        args.each do |path|
          return_me = normalize path
          ::File.unlink return_me
        end
        return return_me
      else
        ::File.unlink @path
        @path
      end
    end
  
    alias :remove   :delete
    alias :destroy  :delete
    alias :del      :delete
    alias :unlink   :delete
    
    # Deletes the file(s) if it exists, does nothing otherwise
    def delete! *args
      unless args.empty?
        return_me = nil
        args.each do |path|
          return_me = normalize path
          ::File.unlink return_me if File.new.exist? path
        end
        return return_me
      else
        ::File.unlink @path if exist?
        @path
      end
    end
    
    alias :remove!  :delete!
    alias :destroy! :delete!
    alias :del!     :delete!
    alias :unlink!  :delete!
    
    # Touches the file passed. Like bash `touch`, but creates
    # all required directories if they don't exist
    def touch *args
      if args.length > 0
        return_me = nil
        args.each do |path|
          return_me = do_create path
        end
        return return_me
      else
        do_create @path
      end
    end
    
    alias :create :touch
    alias :create! :touch
    
    # Returns the contents of the file, all at once
    def read path = nil, &block
      @path = normalize path if path
      unless block
        ::File.read @path
      else
        ::File.open @path, "r" do |the_file|
          block.call the_file
        end
      end
    end

    # Returns true if file exists, false otherwise
    def exist? path = nil
      @path = normalize path if path
      do_check_existence @path
    end
    
    alias :exists? :exist?
    
    def exist_all? *args
      unless args.empty?
        return_me = true
        args.each do |path|
          return_me &= do_check_existence path
        end
        return return_me
      else
        do_check_existence @path
      end
    end
    
    def exist_any? *args
      unless args.empty?
        return_me = false
        args.each do |path|
          return_me |= do_check_existence path
        end
        return return_me
      else
        do_check_existence @path
      end
    end
    
    def exist_which *args
      raise ArgumentError, "Wrong number of arguments (at least one is needed)" if args.empty?
      return_list = []
      args.each do |path|
        return_list << path if do_check_existence path
      end
      return_list
    end
        
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
    
    alias :move :rename

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
    
    alias :move! :rename!
        
    # Appends the contents of the target file into self and erase the target
    def merge *args
      if args.length > 1
        source, target = *args
        @path = normalize source
        target = File.new target
      else
        target = File.new args.first
      end
      
      raise Errno::ENOENT, "No such file - #{@path}" unless exist?
      raise Errno::ENOENT, "No such file - #{target.path}" unless target.exist?
      
      append target.read
      target.delete!
      self
    end
    
    # Returns true if the file is empty or does not exist
    def empty? path = nil
      @path = normalize path if path
      return true if not exist?
      read.empty?
    end
    
    # Copies current file into target file. Does not rely on OS nor FileUtils
    def copy *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = File.new target
      else
        target = File.new args.first
      end
      
      raise ArgumentError, "Target '#{target.path}' already exists." if target.exist?
      do_copy target
    end
    
    def copy! *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = File.new target
      else
        target = File.new args.first
      end
      
      do_copy target
    end
    
    private      
      def do_copy target
        target.write read
        target
      end
            
      def do_create path
        path = normalize path
        Fast::Dir.new.create! ::File.dirname path if ::File.dirname(path) != "."
        ::File.open path, "a+" do |file|
          file.gets; file.write ""
        end
        path
      end

    
      def do_append content
        touch @path unless exist?
        ::File.open @path, "a" do |handler|
          handler.write content
        end
        self
      end
      
      def do_check_existence path
        ::File.exist?(path) && !::File.directory?(path)
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
