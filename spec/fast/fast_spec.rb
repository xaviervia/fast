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
    it "should return an instance of Fast::Dir"
    
    it "should call #list on that instance"
    
    it "should call #create on that instance"
  end
  
  describe ".dir?" do
    it "should return true if passed dir exists"
    
    it "should return false otherwise"
  end
  
  describe ".file" do
    it "should return an instance of Fast::File"
    
    it "should call #read on that instance"
  end
  
  describe ".file!" do
    it "should return an instance of Fast::File"
    
    it "should call #create on that instance"
  end
  
  describe ".file?" do
    it "should return true if file exists"
    
    it "should return false otherwise"
  end
end
