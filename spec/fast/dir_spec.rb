require "fast"
require "pry"

describe Fast::Dir do
  shared_examples_for "any list" do 
    it "should accept a block as an argument"
  end

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
    
    it_behaves_like "any list"
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

    it_behaves_like "any list"
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

    it_behaves_like "any list"
  end
  
  describe "#create" do
    context "is a simple path" do
      it "should create the dir" do
        ::File.should_not be_directory "demo"
        
        Fast::Dir.new.create "demo"
        ::File.should be_directory "demo"
        ::Dir.unlink "demo"
      end
  
      it "should return the directory path" do
        ::File.should_not be_directory "demo"
        "#{Fast::Dir.new.create('demo')}".should include "demo"
        ::Dir.unlink "demo"
      end
    end
    
    context "it is nested within dirs" do
      it "should create the directory tree" do
        ::File.should_not be_directory "demo"
        
        Fast::Dir.new.create "demo/subdir"
        ::File.should be_directory "demo"
        ::File.should be_directory "demo/subdir"

        ::Dir.unlink "demo/subdir"
        ::Dir.unlink "demo"
      end
    end
  end

  describe "#by" do 
    it "should forward self to a filtering object"
    # This is a reminder: along with Serializer, the Filtering pattern
    # (and later, the Sorting one) should be implemented Fast
    
    # I guess filtering in Fast will be done in Fast::FileFilter
  end

  
  shared_examples_for "any deletion" do
    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
    
    it "should delete the directory if it exists" do
      ::File.should_not be_directory "demo"
      Fast::Dir.new.create "demo"
      Fast::Dir.new.send @method, "demo"
      ::File.should_not be_directory "demo"
    end
    
    context "the dir has content" do
      it "should delete the content and the dir" do
        ::File.should_not be_directory "demo"
        
        Fast::Dir.new.create "demo"
        Fast::Dir.new.create "demo/subdir"
        Fast::File.new.touch "demo/in/subdir.txt"
        
        Fast::Dir.new.send @method, "demo"
        
        ::File.should_not exist "demo/in/subdir.txt"
        ::File.should_not be_directory "demo/in"
        ::File.should_not be_directory "demo/subdir"
        ::File.should_not be_directory "demo"
      end
    end
    
    it "should return the deleted dir path"
  end

  describe "#delete" do
    before :each do @method = :delete end
    it_behaves_like "any deletion" 
  end
  
  describe "#del" do 
    before :each do @method = :del end
    it_behaves_like "any deletion" 
  end
  
  describe "#destroy" do 
    before :each do @method = :destroy end
    it_behaves_like "any deletion" 
  end
  
  describe "#unlink" do 
    before :each do @method = :unlink end
    it_behaves_like "any deletion" 
  end
  
  describe "#exist?" do
    it "should return true if the dir exists"
    it "should return false if the dir does not exist"
  end
  
  describe "#to_s" do
    it "should include the path to the dir"
  end

end
