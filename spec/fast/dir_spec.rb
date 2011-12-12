require "fast"
require "zucker/os"

describe Fast::Dir do
  shared_examples_for "any dir list" do 
    context "a block is passed as an argument" do
      it "should pass each entry as argument to the block" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/myfile.txt"
        Fast::File.new.touch "demo/otherfile.txt"
        Fast::Dir.new.create! "demo/subdir"
        
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
    it "should fail if no argument is passed" do
      expect { Fast::Dir.new.send @method 
      }.to raise_error ArgumentError, "No arguments passed, at least one is required"
    end
    
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
    
    it "should work with several arguments" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :alt
      Fast::Dir.new.should_not exist :other
      
      Fast::Dir.new.send @method, :demo, :alt, :other
      
      Fast::Dir.new.should exist :demo
      Fast::Dir.new.should exist :alt
      Fast::Dir.new.should exist :other
      
      Fast::Dir.new.delete! :demo
      Fast::Dir.new.delete! :alt
      Fast::Dir.new.delete! :other
    end
  end
  
  describe "#create" do
    before :each do @method = :create end
    it_behaves_like "any dir creation"
    
    it "should fail if the dir already exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.create :demo
      expect { Fast::Dir.new.create :demo
      }.to raise_error ArgumentError, "Dir 'demo' already exists"
      Fast::Dir.new.delete! :demo
    end
    
    after do
      Fast::Dir.new.delete! :demo
    end
  end
  
  describe "#create!" do
    before :each do @method = :create! end
    it_behaves_like "any dir creation"
    
    it "should do nothing if the dir already exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.create :demo
      expect { Fast::Dir.new.create! :demo
      }.to_not raise_error ArgumentError, "Dir 'demo' already exists"
      Fast::Dir.new.delete! :demo
    end
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
    
    it "should work with several arguments" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :alt
      Fast::Dir.new.should_not exist :other
      
      Fast::Dir.new.create! :demo, :alt, :other
      Fast::Dir.new.send @method, :demo, :alt, :other

      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :alt
      Fast::Dir.new.should_not exist :other
    end
  end

  describe "#delete" do
    before :each do @method = :delete end
    it_behaves_like "any dir deletion" 

    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
  end
  
  describe "#delete!" do
    before :each do @method = :delete! end
    it_behaves_like "any dir deletion"
    
    it "should not fail even if the directory does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.delete! :demo
    end
  end
  
  describe "#del" do 
    before :each do @method = :del end
    it_behaves_like "any dir deletion" 
    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
  end
  
  describe "#destroy" do 
    before :each do @method = :destroy end
    it_behaves_like "any dir deletion" 
    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
  end
  
  describe "#unlink" do 
    before :each do @method = :unlink end
    it_behaves_like "any dir deletion" 

    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
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
  
  describe "#exist_all?"

  describe "#exist_any?"
  
  describe "#exist_which"
  
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
  
  describe "#path" do
    context "the path is setted" do
      it "should return the path" do
        the_dir = Fast::Dir.new "demo"
        the_dir.path.should == "demo"
      end
    end
    
    context "the path is undefined" do
      it "should return nil" do
        the_dir = Fast::Dir.new 
        the_dir.path.should be_nil
      end
    end
  end
  
  shared_examples_for "any dir renaming" do
    it "should delete current dir and target dir should exist" do
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new.should_not exist "renamed"
      Fast::Dir.new.create! "demo"
      Fast::Dir.new.send @method, "demo", "renamed"
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new.should exist "renamed"
      Fast::Dir.new.delete! "renamed"
    end
    
    it "should return a dir with the new dirs name" do
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new.should_not exist "renamed"
      Fast::Dir.new.create! "demo"
      Fast::Dir.new.send( @method, "demo", "renamed" ).path.should == "renamed"
      Fast::Dir.new.delete! "renamed"
    end
    
    it "should contain the same data the target as the source" do
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new.should_not exist "renamed"
      Fast::File.new.touch "demo/content.file"
      Fast::File.new.touch "demo/in/subdir/more.content"
      Fast::File.new.touch "demo/hope.txt"
      
      Fast::Dir.new.send @method, "demo", :renamed # Yeah, symbols work too
      Fast::Dir.new.should_not exist :demo
      Fast::File.new.should exist "renamed/content.file"
      Fast::File.new.should exist "renamed/hope.txt"
      Fast::File.new.should exist "renamed/in/subdir/more.content"
      
      Fast::Dir.new.delete! :renamed
    end
  end

  describe "#rename" do
    before :all do @method = :rename end
    it_behaves_like "any dir renaming"    
    
    it "should fail if the new path represents an existing dir" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :renamed
      Fast::Dir.new.create! :demo
      Fast::Dir.new.create! :renamed
      expect { Fast::Dir.new.rename :demo, :renamed
      }.to raise_error ArgumentError, "The target directory 'renamed' already exists"
      Fast::Dir.new.delete! :demo
      Fast::Dir.new.delete! :renamed
    end
  end
  
  describe "#rename!" do
    before :all do @method = :rename! end
    it_behaves_like "any dir renaming"
    
    it "should overwrite the dir at the new path if it exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :renamed
      Fast::File.new.touch "demo/content.file"
      Fast::File.new.touch "renamed/erase.me"
      
      Fast::Dir.new.rename! :demo, :renamed
      Fast::File.new.should_not exist "renamed/erase.me"
      Fast::File.new.should exist "renamed/content.file"
      Fast::Dir.new.delete! :renamed
    end
  end
  
  shared_examples_for "any dir copy" do
    context "target dir do not exist" do
      it "should create the target dir"
      
      it "should not erase current dir"
    end
    
    it "should be present all of source data in the target" do
      pending "File copy comes first" do
        # All is clean
        Fast::Dir.new.should_not exist :demo
        Fast::Dir.new.should_not exist :target
        
        # Create demo data
        Fast::File.new.touch "demo/content.txt"
        Fast::File.new.touch "demo/more/content/in/subdir.txt"
        
        # Do the copying
        Fast::Dir.new.send @method, :demo, :target
        
        # Check the copy
        Fast::File.new.should exist "target/content.txt"
        Fast::File.new.should exist "target/more/content/in/subdir.txt"
      end
    end
    
    it "should return current dir"
    
    after :all do
      Fast::Dir.new.delete! :demo
      Fast::Dir.new.delete! :target
    end
  end
  
  describe "#copy" do
    it_behaves_like "any dir copy"
    before :all do @method = :copy end
    
    context "in case of conflict in any file" do
      it "should fail"
    
      it "should not do any copying"
    end
  end
  
  describe "#copy!" do
    it_behaves_like "any dir copy"
    before :all do @method = :copy! end
    
    context "in case of conflict" do
      it "should overwrite"
    end
  end
  
  describe "#merge" do
    before :each do 
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :mergeme
    end
    
    it "should delete target dir" do
      Fast::File.new.touch "demo/content.file"
      Fast::File.new.touch "mergeme/mergeable.file"
      
      Fast::Dir.new.merge :demo, :mergeme
      Fast::Dir.new.should_not exist :mergeme
    end
    
    it "should fail if target dir does not exist" do
      Fast::Dir.new.create! :demo
      expect { Fast::Dir.new.merge :demo, :mergeme
      }.to raise_error Errno::ENOENT
    end
    
    it "should put contents of target dir into current dir, recursively" do
      Fast::File.new.touch "demo/content.file"
      Fast::File.new.touch "demo/more.file"
      Fast::File.new.touch "mergeme/data/info.file"
      Fast::File.new.touch "mergeme/info.rb"
      Fast::File.new.touch "mergeme/data/nested/is.informative.file"
      
      Fast::Dir.new.merge :demo, :mergeme
      Fast::Dir.new.should_not exist :mergeme
      
      Fast::File.new.should exist "demo/content.file"
      Fast::File.new.should exist "demo/more.file"
      Fast::File.new.should exist "demo/data/info.file"
      Fast::File.new.should exist "demo/info.rb"
      Fast::File.new.should exist "demo/data/nested/is.informative.file"
    end
    
    context "two fails in the source and target have the same name" do
      it "should fail"
      
      it "should not do any changes in any dir"
    end
    
    after :each do 
      Fast::Dir.new.delete! :demo    if Fast::Dir.new.exist? :demo
      Fast::Dir.new.delete! :mergeme if Fast::Dir.new.exist? :mergeme
    end
  end
  
  describe "#merge!" do
    it "should behave like #merge but never fail"
  end

  describe "#mergeable?" do
    context "both dirs exist and no file or dir in any has the same name in the other" do
      it "should return true"
    end
    
    context "some files in target dir have the same name as other in source" do
      it "should return false"
    end
    
    it "should fail it the target dir does not exist"
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
