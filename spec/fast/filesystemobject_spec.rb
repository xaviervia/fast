require "fast"

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
end