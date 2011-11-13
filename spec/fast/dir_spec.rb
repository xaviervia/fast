require "fast"

describe Fast::Dir do
  describe "#list" do 
    it "should return a list of all items in the directory, excluding '.' & '..'" do
      ::File.should_not be_directory "demo"
      ::Dir.mkdir "demo"
      Fast::File.new.touch "demo/alice.txt"
      Fast::File.new.touch "demo/betty.txt"
      Fast::File.new.touch "demo/chris.txt"
      ::Dir.mkdir "demo/subdir"
      
      Fast::Dir.new.list( "demo" ).should include "alice.txt"
      Fast::Dir.new.list( "demo" ).should include "betty.txt"
      Fast::Dir.new.list( "demo" ).should include "chris.txt"
      Fast::Dir.new.list( "demo" ).should include "subdir"
      Fast::Dir.new.list( "demo" ).should_not include ".."
      Fast::Dir.new.list( "demo" ).should_not include "."
    
      ::Dir.unlink "demo/subdir"
      ::File.unlink "demo/chris.txt"
      ::File.unlink "demo/betty.txt"
      ::File.unlink "demo/alice.txt"
      ::Dir.unlink "demo"
    end
  end
  
  describe "#files" do
    it "should return a list of all files in the directory" do
      ::File.should_not be_directory "demo"
      ::Dir.mkdir "demo"
      Fast::File.new.touch "demo/alice.txt"
      Fast::File.new.touch "demo/betty.txt"
      Fast::File.new.touch "demo/chris.txt"
      ::Dir.mkdir "demo/subdir"
      
      Fast::Dir.new.files( "demo" ).should include "alice.txt"
      Fast::Dir.new.files( "demo" ).should include "betty.txt"
      Fast::Dir.new.files( "demo" ).should include "chris.txt"
      Fast::Dir.new.files( "demo" ).should_not include "subdir"
      Fast::Dir.new.files( "demo" ).should_not include ".."
      Fast::Dir.new.files( "demo" ).should_not include "."
        
      ::Dir.unlink "demo/subdir"
      ::File.unlink "demo/chris.txt"
      ::File.unlink "demo/betty.txt"
      ::File.unlink "demo/alice.txt"
      ::Dir.unlink "demo"
    end
  end
  
  describe "#dirs" do
    it "should return a list containing all dirs in the directory, excludind dots" do
      ::File.should_not be_directory "demo"
      ::Dir.mkdir "demo"
      Fast::File.new.touch "demo/alice.txt"
      Fast::File.new.touch "demo/betty.txt"
      Fast::File.new.touch "demo/chris.txt"
      ::Dir.mkdir "demo/subdir"
      ::Dir.mkdir "demo/endodir"
      
      Fast::Dir.new.dirs( "demo" ).should_not include "alice.txt"
      Fast::Dir.new.dirs( "demo" ).should_not include "betty.txt"
      Fast::Dir.new.dirs( "demo" ).should_not include "chris.txt"
      Fast::Dir.new.dirs( "demo" ).should include "subdir"
      Fast::Dir.new.dirs( "demo" ).should include "endodir"
      Fast::Dir.new.dirs( "demo" ).should_not include ".."
      Fast::Dir.new.dirs( "demo" ).should_not include "."
        
      ::Dir.unlink "demo/subdir"
      ::Dir.unlink "demo/endodir"
      ::File.unlink "demo/chris.txt"
      ::File.unlink "demo/betty.txt"
      ::File.unlink "demo/alice.txt"
      ::Dir.unlink "demo"
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
