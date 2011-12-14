require "fast"

describe Fast do 
  describe ".dir" do
    it "should return an instance of Fast::Dir" do
      Fast.dir.should be_a Fast::Dir
    end
    
    context "a path to a dir is passed and the dir exists" do      
      it "should call #list on that instance" do
        Fast.dir! :demo
        module Fast
          Dir.any_instance.should_receive :list
        end
        
        Fast.dir :demo
      end
      
      after :each do 
        ::Dir.unlink "demo"
      end
    end
  end
  
  describe ".dir!" do
    it "should fail if no argument is passed" do
      expect { Fast.dir!
      }.to raise_error ArgumentError
    end
    
    it "should call #create on that instance" do # So hakzee this one...
      module Fast
        Dir.any_instance.should_receive( :create ).and_return Dir.new( :demo )
      end
      
      Fast.dir.create! :demo
      Fast.dir! :demo
      Fast.dir.delete! :demo
    end

    it "should call #list on that instance" do
      module Fast
        Dir.any_instance.should_receive( :list ).and_return Dir.new
      end
      
      Fast.dir! :demo
    end    
  end
  
  describe ".dir?" do
    before do
      Fast.dir.delete! :demo
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
    
    context "called with argument" do
      it "should call #read on that instance" do
        Fast.file.touch "demo.file"
        module Fast
          File.any_instance.should_receive :read 
        end
        
        Fast.file "demo.file"
        Fast.file.delete! "demo.file"
      end
    end
  end
  
  describe ".file!" do
    it "should fail if not argument is passed" do
      expect { Fast.file!
      }.to raise_error ArgumentError
    end
    
    it "should call #create on that instance" do
      module Fast
        File.any_instance.should_receive :create
      end
      
      Fast.file! "demo.file" 
    end
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
