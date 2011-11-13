require "fast"
require "zucker/os"

describe Fast::Dir do
  shared_examples_for "any dir list" do 
    context "a block is passed as an argument" do
      it "should pass each entry as argument to the block" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/myfile.txt"
        Fast::File.new.touch "demo/otherfile.txt"
        Fast::Dir.new.create "demo/subdir"
        
        iteration = []
        list = Fast::Dir.new.send @method, "demo" do |entry|
          iteration << entry
        end 
                
        iteration.should == list
        
        Fast::Dir.new.delete! "demo"
      end
    end
  end

  describe "#list" do 
    before :each do @method = :list end
    it_behaves_like "any dir list"
    
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
    before :each do @method = :files end
    it_behaves_like "any dir list"

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
    before :each do @method = :dirs end
    it_behaves_like "any dir list"

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
  
  shared_examples_for "any dir creation" do
    context "is a simple path" do
      it "should create the dir" do
        ::File.should_not be_directory "demo"
        
        Fast::Dir.new.send @method, "demo"
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
        
        Fast::Dir.new.send @method, "demo/subdir"
        ::File.should be_directory "demo"
        ::File.should be_directory "demo/subdir"

        ::Dir.unlink "demo/subdir"
        ::Dir.unlink "demo"
      end
    end
    
    context "it is nested within several dirs" do
      it "should create the directory tree" do
        ::File.should_not be_directory "demo"
        
        Fast::Dir.new.send @method, "demo/in/several/subdirs"
        ::File.should be_directory "demo/in/several/subdirs"

        ::Dir.unlink "demo/in/several/subdirs"
        ::Dir.unlink "demo/in/several"
        ::Dir.unlink "demo/in"
        ::Dir.unlink "demo"
      end
    end
  end
  
  describe "#create" do
    before :each do @method = :create end
    it_behaves_like "any dir creation"
  end
  
  describe "#create!" do
    before :each do @method = :create! end
    it_behaves_like "any dir creation"
  end
  
  shared_examples_for "any dir subsetter" do
    # This is a reminder: along with Serializer, the Subsette pattern
    # (and later, the Sorting one) should be implemented Fast
    
    # I guess filtering in Fast will be done in Fast::DirFilter
    it "should forward self to a filtering object" do
      Fast::Dir.new.should_not exist "demo"
      Fast::File.new.touch "demo/in/subdir.file"
      
      the_demo_dir = Fast::Dir.new :demo
      
      Fast::DirFilter.should_receive( :new ).with the_demo_dir
      
      the_demo_dir.by
      
      the_demo_dir.delete!
    end   
  end

  describe "#by" do 
    before :each do @method = :by end
    it_behaves_like "any dir subsetter"
  end
  
  describe "#filter" do
    before :each do @method = :filter end
    it_behaves_like "any dir subsetter"
  end

  
  shared_examples_for "any dir deletion" do
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
    
    it "should return the deleted dir path" do
      ::File.should_not be_directory "demo"
      Fast::Dir.new.create "demo"
      Fast::Dir.new.send( @method, "demo" ).should == "demo"
    end
  end

  describe "#delete" do
    before :each do @method = :delete end
    it_behaves_like "any dir deletion" 
  end
  
  describe "#delete!" do
    before :each do @method = :delete! end
    it_behaves_like "any dir deletion"
  end
  
  describe "#del" do 
    before :each do @method = :del end
    it_behaves_like "any dir deletion" 
  end
  
  describe "#destroy" do 
    before :each do @method = :destroy end
    it_behaves_like "any dir deletion" 
  end
  
  describe "#unlink" do 
    before :each do @method = :unlink end
    it_behaves_like "any dir deletion" 
  end
  
  shared_examples_for "any dir existencialism" do
    it "should return true if the dir exists" do
      ::File.should_not be_directory "demo"
      Fast::Dir.new.create! "demo"
      Fast::Dir.new.send( @method, "demo" ).should be_true
      Fast::Dir.new.delete! "demo"
    end
    
    it "should return false if the dir does not exist" do
      ::File.should_not be_directory "demo"
      Fast::Dir.new.send( @method, "demo" ).should be_false
    end
  end
  
  describe "#exist?" do
    before :each do @method = :exist? end
    it_behaves_like "any dir existencialism"
  end
  
  describe "#exists?" do
    before :each do @method = :exists? end
    it_behaves_like "any dir existencialism"
  end
  
  describe ".new" do
    it "should accept a string path as argument" do
      Fast::Dir.new "demo"
    end
    
    it "should accept a symbol path as argument" do
      Fast::Dir.new :demo
    end
  end
  
  describe "#to_s" do
    it "should include the path to the dir" do
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new(:demo).to_s.should include "demo"
    end
  end

  shared_examples_for "any dir absolutizer" do
    context "dir path is a relative route" do
      it "should expand the dir path with the pwd" do
        Fast::Dir.new.send( @method, :demo ).should == "#{Dir.pwd}/demo"
      end
    end
    
    context "dir path is an absolute route" do
      it "should return the same path as given" do
        unless OS.windows?
          Fast::Dir.new.send( @method, "/dev/null").should == "/dev/null"
        else
          pending "POSIX only!"
        end
      end
    end
  end

  describe "#expand" do
    before :each do @method = :expand end
    it_behaves_like "any dir absolutizer"
  end
  
  describe "#absolute" do
    before :each do @method = :absolute end
    it_behaves_like "any dir absolutizer"
  end
  
  describe "#rename" do
    it "should change the dir's name"
  end

  describe "#[]" do
    context "a file named like the argument exists" do
      it "should return it"
    end
    
    context "a dir named like the argument exists" do
      it "should return it"
    end
    
    context "there's nothing there" do
      it "should return nil"
    end
  end
  
  describe "#[]=" do # This is an absolute WIN
    it "should create the file with the given content"
  end

end
