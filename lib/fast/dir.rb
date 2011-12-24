require "sub-setter/fast/dir"  # This call should be automated in the sub-setter API somehow

module Fast
  # Directory handling class
  class Dir < Array
    def initialize path = nil
      super()
      @path = normalize path if path
    end
    
    # Returns a Fast::Dir list with all items in the directory, except ".." and "."
    def list path = nil, &block
      @path = normalize path unless path.nil?
      ::Dir.foreach @path do |entry|
        unless entry == "." or entry == ".."
          self << entry 
          block.call entry if block
        end
      end
      self
    end
    
    # Returns a Fast::Dir list of all files in the directory. Non recursive 
    # (at least yet)
    def files path = nil, &block
      @path = normalize path if path
      ::Dir.foreach @path do |entry|
        unless ::File.directory? "#{@path}/#{entry}"
          self << entry 
          block.call entry if block
        end
      end
      self
    end
    
    # Returns a Fast::Dir list of all directories in the directory, non-recursive
    # and excluding points
    def dirs path = nil, &block
      @path = normalize path if path
      ::Dir.foreach @path do |entry|
        if ::File.directory? "#{@path}/#{entry}" and entry != "." and entry != ".."
          self << entry 
          block.call entry if block
        end
      end
      self
    end

    # Creates the dir, if it doesn't exist. Otherwise raises an ArgumentException
    # Returns the last dir path passed as argument
    def create *args
      if args.length > 0
        return_me = nil
        args.each do |path|
          raise ArgumentError, "Dir '#{path}' already exists" if Dir.new.exist? path
          return_me = do_create path
        end
        return return_me
      else
        raise ArgumentError, "No arguments passed, at least one is required" unless @path
        raise ArgumentError, "Dir '#{@path}' already exists" if Dir.new.exist? @path
        do_create @path
      end
    end

    # Creates the dir, if it doesn't exist. Otherwise remains silent
    # Returns the last dir path passed as argument
    def create! *args
      if args.length > 0
        return_me = nil
        args.each do |path|
          return_me = do_create path
        end
        return return_me
      else
        raise ArgumentError, "No arguments passed, at least one is required" unless @path
        do_create @path
      end
    end
  
    # Deletes the directory along with all its content. Powerful, simple, risky!
    # Many arguments can be passed
    def delete *args
      if args.length > 0
        return_me = nil
        args.each do |path|
          return_me = do_delete path
        end
        return return_me
      else
        do_delete
      end
    end
  
    alias :destroy :delete
    alias :del :delete
    alias :unlink :delete
    alias :remove :delete
    
    # Like #delete, but raises no error if some directory is missing
    def delete! *args
      if args.length > 0
        return_me = nil
        args.each do |path|
          begin
            return_me = do_delete path
          rescue
            return_me = nil
          end
        end
        return return_me
      else
        begin
          do_delete
        rescue
          nil
        end
      end
    end
    
    alias :remove! :delete!
    
    # Checks for existence. True if the directory exists, false otherwise
    def exist? path = nil
      @path = normalize path if path
      ::File.directory? @path
    end
    
    alias :exists? :exist?
   
    # Returns true if all passed dirs exist, false otherwise
    def exist_all? *args
      unless args.empty?
        args.each do |path|
          return false if not Dir.new.exist? path
        end
        return true
      else
        exist?
      end
    end
    
    # Returns true if any of passed dirs exists, false otherwise
    def exist_any? *args
      unless args.empty?
        args.each do |path|
          return true if Dir.new.exist? path
        end
        return false
      else
        exist?
      end
    end
    
    # Return a list with the existing dirs path
    # Note: This should be delegated to the SubSetter::Fast::Dir
    def exist_which *args
      if args.empty?
        raise ArgumentError, "Wrong number of arguments, at least one dir should be passed"
      end
      
      existing_ones = []
      args.each do |path|
        existing_ones << path if Dir.new.exist? path
      end

      return existing_ones
    end
  
    # Returns a String brief of the dir
    def to_s
      return "#{@path}"
    end
    
    # Sends self to a SubSetter for Fast::Dir
    def filter
      SubSetter::Fast::Dir.new self
    end
    
    alias :by :filter

    # Expands the path to absolute is it is relative
    def expand path = nil
      @path = normalize path if path
      ::File.expand_path @path
    end
    
    alias :absolute :expand
        
    # Returns the path to the dir, if defined
    def path
      @path if @path
    end    
    
    # Renames this dir into the target path, unless the target path 
    # points to an existing dir.
    def rename *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = normalize target
      else
        target = normalize args.first
      end

      raise ArgumentError, "The target directory '#{target}' already exists" if Dir.new.exist? target
      do_rename_to target
    end
   
    alias :move :rename
    
    # Renames this dir into the target path: overwrites the target dir 
    # if it exists
    def rename! *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = normalize target
      else
        target = normalize args.first
      end
      Dir.new.delete! target if Dir.new.exist? target
      do_rename_to target
    end
    
    alias :move! :rename!
    
    # Merges the target dir into this
    def merge *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = normalize target
      else
        target = normalize args.first
      end
      
      Dir.new.list target do |entry|
        unless Dir.new.exist? "#{target}/#{entry}"
          File.new.rename "#{target}/#{entry}", "#{@path}/#{entry}"
        else
          Dir.new.rename "#{target}/#{entry}", "#{@path}/#{entry}"
        end
      end
      
      Dir.new.delete target
    end
    
    def copy *args
      if args.length > 1
        current, target = *args
        @path = normalize current
        target = Dir.new target
      else
        target = Dir.new args.first
      end
      
      target.create
      list do |entry|
        if File.new.exist? "#{@path}/#{entry}" # This is a "is file?" check and should be more obvious
          File.new.copy "#{@path}/#{entry}", "#{target.path}/#{entry}"
        else # is a Dir then
          Dir.new.copy "#{@path}/#{entry}", "#{target.path}/#{entry}"
        end
      end
    end
    
    alias :copy! :copy
    
    def [] name
      if name.is_a? Integer # I do not wish to disable Array behaviour
        super
      else
        return Dir.new "#{@path}/#{name}" if dirs.include? normalize name
        return File.new "#{@path}/#{name}" if files.include? normalize name
      end
    end
    
    def []= name, content
      if name.is_a? Integer # I do not wish to disable Array behaviour
        super 
      else
        return File.new.write "#{@path}/#{name}", content       
      end
    end
    
    private
      def do_delete path = nil
        @path = normalize path if path
        Dir.new.list @path do |entry|
          if ::File.directory? "#{@path}/#{entry}"
            Dir.new.delete "#{@path}/#{entry}" 
          else
            ::File.unlink "#{@path}/#{entry}" 
          end
        end
        ::Dir.unlink @path
        @path
      end

      def do_create path = nil
        @path = normalize path if path
        route = []
        @path.split("/").each do |part|
          unless part.empty?
            route << part
            unless ::File.directory? route.join "/"
              ::Dir.mkdir route.join "/" 
            end
          end
        end unless ::File.directory? @path
        self
      end

      def do_rename_to target
        # 1. Create the target dir
        target_dir = Dir.new.create! target
        
        # 2. Move all files
        files do |file|
          File.new.rename "#{@path}/#{file}", "#{target_dir}/#{file}"
        end
        
        # 3. Rename recursively all dirs
        dirs do |dir|
          Dir.new.rename "#{@path}/#{dir}", "#{target_dir}/#{dir}"
        end
        
        # 4. Delete current dir
        self.delete!
        
        target_dir
      end
      
      def normalize path
        "#{path}"
      end
  end
end
