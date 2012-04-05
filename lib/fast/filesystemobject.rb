module Fast
  module FilesystemObject
    # If a string is passed, returns the same string;
    # if a symbol is passed, returns the string representation
    # of the symbol; if an object of the same class as self
    # is passed, return the #path of that object
    def normalize path
      if path.instance_of? String or path.instance_of? Symbol
        "#{path}"
      elsif path.instance_of? self.class
        path.path
      end
    end
    
    # Returns the path to the current FilesystemObject
    def path
      @path
    end
    
    # Expands the path if it's a relative path
    def expand path = nil
      @path = normalize path if path
      raise Fast::PathNotSettedException, "The path was not setted in this instance" unless @path
      ::File.expand_path @path
    end
    
    alias :absolute :expand
  end
end