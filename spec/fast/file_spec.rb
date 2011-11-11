require "fast"

describe Fast::File do
  describe "#append" do
    it "should create the file if it does not exists"
    
    it "should not erase the content of the file if it has some"
    
    it "should append the new content last in the file"
    
    it "should not update the creation time"
    
    it "should update the modification time"
    
    it "should return the path to the file"
  end
  
  describe "#delete" do
    it "should delete the file"
    
    it "should return the path of the deleted file"
  end
  
  describe "#touch" do
    context "in current folder" do
      it "should create the file if it does not exist"
      
      it "should not rise any error if the file already exists"
      
      it "should not change its creation time if already exists"
    end
    
    context "the file is inside a directory" do
      it "should create the file if it does not exist"
    end
    
    context "the file is inside a non existing directory" do
      it "should create the directory aswell as the file"
    end
    
    it "should return the path to the newly created file"
  end  
end
