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
end