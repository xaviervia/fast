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

    # #create
  
    # #exist?
    
    private
      def normalize path
        @path = "#{path}"
      end
  end
end
