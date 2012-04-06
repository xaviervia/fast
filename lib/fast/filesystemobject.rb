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
  
    # Returns true if the item exists, false otherwise: 
    # relays on the implementation of a private #do_check?
    # method in the class that includes the module
    def exist? path = nil
      if path
        path = normalize path
        @path = path unless @path
        do_exist? path
      else
        raise ArgumentError, "An argument should be provided if this instance has no path setted" unless @path
        do_exist? @path
      end
    end
    
    alias :exists? :exist?
    
    def exist_all? *args
      unless args.empty?
      else
        raise ArgumentError, "An argument should be provided if this instance has no path setted" unless @path
        do_exist? @path
      end
    end
    
    def exist_any? *args
      unless args.empty?
      else
        raise ArgumentError, "An argument should be provided if this instance has no path setted" unless @path
        do_exist? @path
      end
    end
    
    private
    
    # Abstract implementation to be overriden in the 
    # actual classes.
    def do_exist? path
      raise NotImplementedError, "The implementation of #do_exist? in the module FilesystemObject is abstract, please reimplement in any class including it."
    end
  end
end