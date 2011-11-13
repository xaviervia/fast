module Fast
  # Directory handling class
  class Dir < Array
    # .call -> like Fast::File.call -> NOUP: make delegator pattern Singleton-like
    
    # Returns a Fast::Dir list with all items in the directory, except ".." and "."
    def list path = nil
      @path = normalize path if path
      ::Dir.foreach @path do |entry|
        self << entry unless entry == "." or entry == ".."
      end
      self
    end
    
    # Returns a Fast::Dir list of all files in the directory. Non recursive 
    # (at least yet)
    def files path = nil
      @path = normalize path if path
      ::Dir.foreach @path do |entry|
        self << entry unless ::File.directory? "#{@path}/#{entry}"
      end
      self
    end
    
    # Returns a Fast::Dir list of all directories in the directory, non-recursive
    # and excluding points
    def dirs path = nil
      @path = normalize path if path
      ::Dir.foreach @path do |entry|
        self << entry if ::File.directory? "#{@path}/#{entry}" and entry != "." and entry != ".."
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
  
    def delete path = nil
      @path = normalize path if path
      Dir.new.list( @path ).each do |entry|
        if ::File.directory? "#{@path}/#{entry}"
          Dir.new.delete "#{@path}/#{entry}" 
        else
          ::File.unlink "#{@path}/#{entry}" 
        end
      end
      ::Dir.unlink @path
      @path
    end
  
    alias :destroy :delete
    alias :del :delete
    alias :unlink :delete
    # #exist?
  
    # Returns a String brief of the dir
    def to_s
      return "#{@path}"
    end
    
    private
      def normalize path
        @path = "#{path}"
      end
  end
end
