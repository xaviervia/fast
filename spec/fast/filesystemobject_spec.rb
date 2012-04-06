require "fast"
require "zucker/os"

describe Fast::FilesystemObject do
  describe "#normalize" do
    context "string as a argument" do
      it "should return the same string" do
        the_object = stub "object"
        the_object.extend Fast::FilesystemObject
        the_object.normalize("hola").should == "hola"
      end
    end
    
    context "symbol as a argument" do
      it "should return the string representation of that symbol" do
        the_object = stub "object"
        the_object.extend Fast::FilesystemObject
        the_object.normalize(:hola).should == "hola"
      end
    end
    
    context "instance of the same class as argument" do
      it "should return the #path of the instance" do
        the_object = stub "object"
        the_object.extend Fast::FilesystemObject
        the_argument = stub "object"
        the_argument.stub(:path).and_return "hola"
        the_object.normalize(the_argument).should == "hola"
      end
    end
    
    context "no argument passed" do
      it "should fail" do
        the_object = stub "object"
        the_object.extend Fast::FilesystemObject
        expect { the_object.normalize
        }.to raise_error ArgumentError
      end
    end
  end
  
  describe "#path" do
    context "the path is setted" do
      it "should return the variable path" do
        the_object = stub "object"
        def the_object.add_path
          @path = "hola"
        end
        the_object.add_path
        the_object.extend Fast::FilesystemObject
        the_object.path.should == "hola"
      end
    end

    context "the path is undefined" do
      it "should return nil" do
        the_object = stub "object"
        the_object.extend Fast::FilesystemObject
        the_object.path.should be_nil
      end
    end
  end
  
  shared_examples_for "any path absolutizer" do
    context "using existing @path in object" do
      context "path is a relative route" do
        it "should expand the path with pwd" do
          the_object = stub "object"
          def the_object.set_path
            @path = "demo.file"
          end
          the_object.set_path
          the_object.extend Fast::FilesystemObject
          the_object.send( @method ).should == "#{Dir.pwd}/demo.file"
        end
      end
      
      context "path is an absolute route" do
        it "should return the same as given path" do
          unless OS.windows?
            the_object = stub "object"
            def the_object.set_path
              @path = "/dev/null"
            end
            the_object.set_path
            the_object.extend Fast::FilesystemObject
            the_object.send( @method ).should == "/dev/null"
          else
            pending "POSIX only!"
          end        
        end
      end
    
      context "no path is setted" do
        it "should fail with custom error" do
          the_object = stub "object"
          the_object.extend Fast::FilesystemObject
          expect { the_object.send @method
          }.to raise_error Fast::PathNotSettedException, "The path was not setted in this instance"
        end
      end
    end
    
    context "giving path as argument" do
      context "the path is a relative route" do
        it "should expand the path with pwd" do
          the_object = stub "object"
          the_object.extend Fast::FilesystemObject
          the_object.send( @method, "demo.file" ).should == "#{Dir.pwd}/demo.file"
        end
      end
      
      context "path is an absolute route" do
        it "should return the same as the given path" do
          the_object = stub "object"
          the_object.extend Fast::FilesystemObject
          the_object.send( @method, "/dev/null" ).should == "/dev/null"
        end
      end
    end
  end
  
  describe "#expand" do
    before { @method = :expand }
    it_behaves_like "any path absolutizer"
  end
  
  describe "#absolute" do
    before { @method = :absolute }
    it_behaves_like "any path absolutizer"
  end
  
  shared_examples_for "any item existencialism" do
    it "should call the method #do_exist?" do
      the_object = Object.new
      the_object.extend Fast::FilesystemObject
      def the_object.path
        @path = "somepath"
      end
      the_object.path
      the_object.should_receive(:do_exist?).with("somepath")
      the_object.send @method
    end
    
    context "no argument and no @path was setted" do
      it "should fail" do
        an_obj = Object.new
        an_obj.stub :do_exist?
        an_obj.extend Fast::FilesystemObject
        expect { an_obj.send @method
        }.to raise_error ArgumentError, "An argument should be provided if this instance has no path setted"
      end
    end
    
    context "@path was setted previously" do
      context "should return the same as #do_exist?" do
        it "when exists is true" do
          o = Object.new
          o.extend Fast::FilesystemObject
          def o.set; @path = "p"; end
          o.set
          
          o.should_receive(:do_exist?).with("p").and_return(true)
          o.send(@method).should === true
        end
        
        it "when does not exist is false" do
          o = Object.new
          o.extend Fast::FilesystemObject
          def o.set; @path = "p"; end
          o.set
          
          o.should_receive(:do_exist?).with("p").and_return(false)
          o.send(@method).should === false
        end
      end
    end
  end
  
  shared_examples_for "any single argument existencialism" do
    it_behaves_like "any item existencialism"
    
    it "Fast::File#exist? & Fast::Dir#exist? should be replaced with these"
    
    it "should not accept more than one argument" do
      o = Object.new
      o.extend Fast::FilesystemObject
      expect { o.send @method, "one", "two"
      }.to raise_error ArgumentError
    end
    
    context "when receiving an argument" do
      it "should normalize it" do
        o = Object.new
        o.extend Fast::FilesystemObject
        o.should_receive(:normalize).with("mypath")
        o.stub :do_exist?
        o.send @method, "mypath"
      end
      
      context "if path wasn't setted" do
        it "should set @path" do
          o = Object.new
          o.extend Fast::FilesystemObject
          o.stub :do_exist?
          o.send @method, :mypath
          o.path.should == "mypath"
        end
      end
      
      context "if @path was set" do
        it "should not change path" do
          o = Object.new
          o.extend Fast::FilesystemObject
          o.stub :do_exist?
          def o.set_path; @path = "other"; end
          o.set_path
          o.send @method, :mypath
          o.path.should == "other"
        end
      end 
      
      it "should call do_exist? with the given path" do
        o = Object.new
        o.extend Fast::FilesystemObject
        o.should_receive(:do_exist?).with("apath")
        o.send @method, :apath
      end

      it "when exists is true" do
        o = Object.new
        o.extend Fast::FilesystemObject
        
        o.should_receive(:do_exist?).with("p").and_return(true)
        o.send(@method, "p").should === true
      end
      
      it "when does not exist is false" do
        o = Object.new
        o.extend Fast::FilesystemObject
        
        o.should_receive(:do_exist?).with("p").and_return(false)
        o.send(@method, "p").should === false
      end
    end
  end
  
  describe "#exist?" do
    before { @method = :exist? }
    it_behaves_like "any single argument existencialism"
  end
  
  describe "#exists?" do
    before { @method = :exists? }
    it_behaves_like "any single argument existencialism"
  end
  
  describe "#exist_all?" do
    before { @method = :exist_all? }
    it_behaves_like "any item existencialism"
    it "should implement mass checking of arguments"
  end
  
  describe "#exist_any?" do
    before { @method = :exist_any? }
    it_behaves_like "any item existencialism"
    it "should implement mass checking of arguments"
  end
  
  # Private methods here
  describe "#do_exist?" do
    context "when called as public" do
      it "should raise an exception related with private method" do
        obj = Object.new
        obj.extend Fast::FilesystemObject
        expect { obj.do_exist?
        }.to raise_error NoMethodError, /private method/
      end
    end
    
    context "when called as private" do
      it "should raise ArgumentError when called without arguments" do
        obj = Object.new
        obj.extend Fast::FilesystemObject
        def obj.test
          do_exist?
        end
        
        expect { obj.test
        }.to raise_error ArgumentError
      end
      
      it "should raise a NotImplementedException when called with an argument" do
        o = Object.new
        o.extend Fast::FilesystemObject
        def o.t
          do_exist? "path"
        end
        
        expect { o.t
        }.to raise_error NotImplementedError, "The implementation of #do_exist? in the module FilesystemObject is abstract, please reimplement in any class including it."
      end
    end
  end
end