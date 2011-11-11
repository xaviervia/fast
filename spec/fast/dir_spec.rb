require "fast"

describe Fast::Dir do
  describe "#list" do 
    it "should return a list of all items in the directory"
  end
  
  describe "#files" do
    it "should return a list of all files in the directory"
    
    context "args :extension => 'txt'" do
      it "should return a list of all files with .txt as extension in the directory"
    end
  end
  
  describe "#dirs" do
    it "should return a list containing all dirs in the directory"
    
    context "args :skip => :dots" do
      it "should return a list of dirs excluding '.' and '..'"
    end
  end
  
  describe "#create" do
    context "is a simple path" do
      it "should create the dir"
  
      it "should return the directory path"
    end
    
    context "it is nested within dirs" do
      it "should create the directory tree"
    end
  end
end
