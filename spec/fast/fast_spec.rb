require "fast"

describe Fast do 
  describe ".dir" do
    it "should return an instance of Fast::Dir" do
      Fast.dir.should be_a Fast::Dir
    end
    
    context "a path to an existing dir is passed" do
      before do
        Fast.dir.should_not exist :demo
        Fast.dir.create! :demo
        Fast::File.new.touch "demo/my.file"
        Fast::File.new.touch "demo/other.file"
      end
      
      it "should call #list on that instance" do
        pending "Don't remember how to stub for instances"
      end
      
      after do
        Fast.dir.delete! :demo
      end
    end
  end
  
  describe ".dir!" do
    it "should fail if no argument is passed" do
      expect { Fast.dir!
      }.to raise_error ArgumentError
    end
    
    it "should call #list on that instance"
    
    it "should call #create on that instance"
  end
  
  describe ".dir?" do
    before do
      Fast.dir.should_not exist :demo
    end
    
    it "should return true if passed dir exists" do
      Fast.dir.create! :demo
      Fast.dir?(:demo).should be_true
      Fast.dir.delete! :demo
    end
    
    it "should return false otherwise" do
      Fast.dir?(:demo).should be_false
    end
  end
  
  describe ".file" do
    it "should return an instance of Fast::File" do
      Fast.file.should be_a Fast::File
    end
    
    it "should call #read on that instance"
  end
  
  describe ".file!" do
    it "should fail if not argument is passed" do
      expect { Fast.file!
      }.to raise_error ArgumentError
    end
    
    it "should call #create on that instance"
  end
  
  describe ".file?" do
    before do
      Fast.file.should_not exist "demo.file"
    end
    
    it "should return true if file exists" do
      Fast.file.create! "demo.file"
      Fast.file?("demo.file").should be_true
      Fast.file.delete! "demo.file"
    end
    
    it "should return false otherwise" do
      Fast.file?("demo.file").should be_false
    end
  end
end
