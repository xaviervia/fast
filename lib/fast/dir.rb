module Fast
  # Directory handling class
  class Dir < Array
    # .call -> like Fast::File.call -> NOUP: make delegator pattern Singleton-like
    def initialize path = nil
      super()
      @path = normalize path if path
    end
    
    # Returns a Fast::Dir list with all items in the directory, except ".." and "."
    def list path = nil, &block
      @path = normalize path if path
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

    # Creates the dir, if it doesn't exist. Otherwise remains silent
    def create path = nil
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
    
    alias :create! :create
  
    # Deletes the directory along with all its content. Powerful, simple, risky!
    def delete path = nil
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
  
    alias :delete! :delete
    alias :destroy :delete
    alias :del :delete
    alias :unlink :delete
    
    # Checks for existence. True if the directory exists, false otherwise
    def exist? path = nil
      @path = normalize path if path
      ::File.directory? @path
    end
    
    alias :exists? :exist?
  
    # Returns a String brief of the dir
    def to_s
      return "#{@path}"
    end
    
    # Sends self to a DirFilter filter
    def filter
      DirFilter.new self
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
      # 1. Create the target dir
      # 2. Move all files
      # 3. Rename recursively all dirs
      # 4. Delete current dir
   end
    
    private
      def normalize path
        @path = "#{path}"
      end
  end
end
