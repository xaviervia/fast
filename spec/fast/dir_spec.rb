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

    context "the method is called in an instance of Fast::Dir" do
      it "should return the files only" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/alice.txt"
        Fast::File.new.touch "demo/betty.txt"
        Fast::File.new.touch "demo/chris.txt"
        Fast::Dir.new.create! "demo/subdir"
        
        the_dir = Fast::Dir.new :demo
        the_dir.files.should include "alice.txt"
        the_dir.files.should include "betty.txt"
        the_dir.files.should include "chris.txt"
        the_dir.files.should_not include "subdir"
        the_dir.files.should_not include ".."
        the_dir.files.should_not include "."
        
        Fast::Dir.new.delete! :demo
      end
    end
    
    context "the method is called after #list has been called on this instance" do
      it "should return the files only" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/alice.txt"
        Fast::File.new.touch "demo/betty.txt"
        Fast::File.new.touch "demo/chris.txt"
        Fast::Dir.new.create! "demo/subdir"
        
        the_dir = Fast::Dir.new :demo
        the_dir.list
        the_dir.files.should include "alice.txt"
        the_dir.files.should include "betty.txt"
        the_dir.files.should include "chris.txt"
        the_dir.files.should_not include "subdir"
        the_dir.files.should_not include ".."
        the_dir.files.should_not include "."
        
        Fast::Dir.new.delete! :demo
      end
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

    context "the method is called in an instance of Fast::Dir" do
      it "should return the dirs only" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/alice.txt"
        Fast::File.new.touch "demo/betty.txt"
        Fast::File.new.touch "demo/chris.txt"
        Fast::Dir.new.create! "demo/subdir"
        
        the_dir = Fast::Dir.new :demo
        the_dir.dirs.should_not include "alice.txt"
        the_dir.dirs.should_not include "betty.txt"
        the_dir.dirs.should_not include "chris.txt"
        the_dir.dirs.should include "subdir"
        the_dir.dirs.should_not include ".."
        the_dir.dirs.should_not include "."
        
        Fast::Dir.new.delete! :demo
      end
    end

    context "the method is called after #list has been called on this instance" do
      it "should return the dirs only" do
::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/alice.txt"
        Fast::File.new.touch "demo/betty.txt"
        Fast::File.new.touch "demo/chris.txt"
        Fast::Dir.new.create! "demo/subdir"
        
        the_dir = Fast::Dir.new :demo
        the_dir.list
        the_dir.dirs.should_not include "alice.txt"
        the_dir.dirs.should_not include "betty.txt"
        the_dir.dirs.should_not include "chris.txt"
        the_dir.dirs.should include "subdir"
        the_dir.dirs.should_not include ".."
        the_dir.dirs.should_not include "."
        
        Fast::Dir.new.delete! :demo
      end
    end
  end
  
  shared_examples_for "any dir creation" do
    it "should fail if no argument is passed" do
      expect { Fast::Dir.new.send @method 
      }.to raise_error ArgumentError, "No arguments passed, at least one is required"
    end
    
    context "from an existing Dir object" do
      it "should create the dir" do
        Fast::Dir.new.should_not exist :demo
        the_dir = Fast::Dir.new :demo
        the_dir.send @method
        the_dir.should exist
        the_dir.remove
      end
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
    
    context "no path is setted and a Hash is passed" do
      it "build the entire structure in the current dir" do
        Fast::Dir.new.should_not exist :demo
        Fast::Dir.new.should_not exist :demo2
        
        Fast::Dir.new.send @method, { 
          :demo => {
            :Superfile => "With some content",
            :subdir => {
              "deep.txt" => "In the structure."
            }
          },
          :demo2 => {}
        }
        
        Fast::File.new.read("demo/Superfile").should == "With some content"
        Fast::File.new.read("demo/subdir/deep.txt").should == "In the structure."
        
        Fast::Dir.new.should exist :demo2
      end
    
      after do
        Fast::Dir.new.delete! :demo
        Fast::Dir.new.delete! :demo2
      end
    end

    context "a path is setted in the Dir and a Hash is passed" do
      it "build the entire structure in the right dir" do
        Fast::Dir.new.should_not exist :demo
        
        Fast::Dir.new("demo").send @method, { 
          :inner => {
            :Superfile => "With some content",
            :subdir => {
              "deep.txt" => "In the structure."
            }
          },
          :meta => {}
        }
        
        Fast::File.new.read("demo/inner/Superfile").should == "With some content"
        Fast::File.new.read("demo/inner/subdir/deep.txt").should == "In the structure."
        
        Fast::Dir.new.should exist "demo/meta"
      end
    
      after do
        Fast::Dir.new.delete! :demo
      end
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
    
    it "should fail is a Hash is passed an there are conflicts"
    
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
    
    it "should override if a Hash is passed and there are conflicts"
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

  describe "#del!" do
    before :each do @method = :del! end
    it_behaves_like "any dir deletion"
    
    it "should not fail even if the directory does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.del! :demo
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

  describe "#destroy!" do
    before :each do @method = :destroy! end
    it_behaves_like "any dir deletion"
    
    it "should not fail even if the directory does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.destroy! :demo
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
  
  describe "#unlink!" do
    before :each do @method = :delete! end
    it_behaves_like "any dir deletion"
    
    it "should not fail even if the directory does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.unlink! :demo
    end
  end

  describe "#remove" do
    before :each do @method = :remove end
    it_behaves_like "any dir deletion" 

    it "should fail if the directory does not exist" do
      ::File.should_not be_directory "demo"
      expect { Fast::Dir.new.send @method, "demo"
      }.to raise_error
    end
  end
  
  describe "#remove!" do
    before :each do @method = :remove! end
    it_behaves_like "any dir deletion"
    
    it "should not fail even if the directory does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.remove! :demo
    end
  end
  
  # Private method
  describe "#do_exist?" do
    context "if the path is a directory" do
      it "should return true if the passed path is a directory" do
        ::File.should_not be_directory "demo"
        dir = Fast::Dir.new "demo"
        dir.create!
        def dir.call_do_exist?
          do_exist? "demo"
        end
        dir.call_do_exist?.should === true
      end
  
      after do
        Fast::Dir.new.destroy! "demo"
      end
    end

    it "should return false if the passed path is not a directory" do
      ::File.should_not be_directory "demo"
      dir = Fast::Dir.new "demo"
      def dir.call_do_exist?
        do_exist? "demo"
      end
      dir.call_do_exist?.should === false
    end
  end

  shared_examples_for "any dir existencialism" do
    it "should return true if the dir exists" do
      pending "move partially to FilesystemObject"
      ::File.should_not be_directory "demo"
      Fast::Dir.new.create! "demo"
      Fast::Dir.new.send( @method, "demo" ).should be_true
      Fast::Dir.new.delete! "demo"
    end
    
    it "should return false if the dir does not exist" do
      pending "move partially to FilesystemObject"
      ::File.should_not be_directory "demo"
      Fast::Dir.new.send( @method, "demo" ).should be_false
    end
  end
    
  describe "#exist_all?" do
    before :each do @method = :exist_all? end
    it_behaves_like "any dir existencialism"
    
    it "should return true if all exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :demo2
      Fast::Dir.new.should_not exist :demo3
      
      Fast::Dir.new.create :demo, :demo2, :demo3
      
      Fast::Dir.new.exist_all?(:demo, :demo2, :demo3).should be_true
      
      Fast::Dir.new.remove :demo, :demo2, :demo3
    end
    
    it "should return false if any does not exist" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :demo2
      Fast::Dir.new.should_not exist :demo3
      
      Fast::Dir.new.create :demo, :demo2
      
      Fast::Dir.new.exist_all?(:demo, :demo2, :demo3).should be_false
      
      Fast::Dir.new.remove :demo, :demo2
    end
  end

  describe "#exist_any?" do
    it_behaves_like "any dir existencialism"
    before :each do @method = :exist_any? end
    
    it "should return true if at least one exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :demo2
      Fast::Dir.new.should_not exist :demo3
      
      Fast::Dir.new.create :demo, :demo2
      
      Fast::Dir.new.exist_any?(:demo, :demo2, :demo3).should be_true
      
      Fast::Dir.new.remove! :demo, :demo2, :demo3
    end
    
    it "should return false if none exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :demo2
      Fast::Dir.new.should_not exist :demo3
            
      Fast::Dir.new.exist_any?(:demo, :demo2, :demo3).should be_false
    end
  end
  
  describe "#exist_which" do
    it "should return a list with the dir that exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :demo2
      Fast::Dir.new.should_not exist :demo3
      
      Fast::Dir.new.create :demo, :demo2
      
      the_list = Fast::Dir.new.exist_which :demo, :demo2, :demo3
      the_list.should include :demo
      the_list.should include :demo2
      the_list.should_not include :demo3
      
      Fast::Dir.new.remove! :demo, :demo2, :demo3
    end
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
  

  describe "#move" do
    before :all do @method = :move end
    it_behaves_like "any dir renaming"    
    
    it "should fail if the new path represents an existing dir" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :renamed
      Fast::Dir.new.create! :demo
      Fast::Dir.new.create! :renamed
      expect { Fast::Dir.new.move :demo, :renamed
      }.to raise_error ArgumentError, "The target directory 'renamed' already exists"
      Fast::Dir.new.delete! :demo
      Fast::Dir.new.delete! :renamed
    end
  end
  
  describe "#move!" do
    before :all do @method = :move! end
    it_behaves_like "any dir renaming"
    
    it "should overwrite the dir at the new path if it exists" do
      Fast::Dir.new.should_not exist :demo
      Fast::Dir.new.should_not exist :renamed
      Fast::File.new.touch "demo/content.file"
      Fast::File.new.touch "renamed/erase.me"
      
      Fast::Dir.new.move! :demo, :renamed
      Fast::File.new.should_not exist "renamed/erase.me"
      Fast::File.new.should exist "renamed/content.file"
      Fast::Dir.new.delete! :renamed
    end
  end
  
  shared_examples_for "any dir copy" do
    before :each do 
      Fast::Dir.new.should_not exist :demo      
      Fast::Dir.new.should_not exist :target
    end
    
    context "target dir do not exist" do
      it "should create the target dir" do
        Fast::Dir.new.create :demo
        
        Fast::Dir.new.send @method, :demo, :target
        
        Fast::Dir.new.should exist :target
      end
      
      it "should not erase current dir" do
        Fast::Dir.new.create :demo
        
        Fast::Dir.new.send @method, :demo, :target
        
        Fast::Dir.new.should exist :demo
      end
    end
    
    it "should be present all of source data in the target" do        
      # Create demo data
      Fast::File.new.touch "demo/content.txt"
      Fast::File.new.touch "demo/more/content/in/subdir.txt"
      Fast::Dir.new.create "demo/empty_dir"
      
      # Do the copying
      Fast::Dir.new.send @method, :demo, :target
      
      # Check the copy
      Fast::File.new.should exist "target/content.txt"
      Fast::File.new.should exist "target/more/content/in/subdir.txt"
      Fast::Dir.new.should exist "target/empty_dir"
    end
    
    it "should return the current dir" do
      the_dir = Fast::Dir.new.create! :demo
      # Do the copying
      the_dir.send(@method, :target).should be the_dir      
    end
    
    after :each do
      Fast::Dir.new.delete! :demo, :target
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
    
    context "two files in the source and target have the same name" do
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

  describe "#conflicts_with?" do
    context "no directory tree" do
      context "no file in target has the same name as other in source" do
        it "should return false" do
          Fast::Dir.new.should_not exist :target
          Fast::Dir.new.should_not exist :demo
          
          Fast::File.new.touch "demo/non_conflict.txt"
          Fast::File.new.touch "target/not_at_all.txt"
          
          Fast::Dir.new.conflicts_with?(:demo, :target).should === false
        end
      end
      
      context "at least one file in target has the same name as other in source" do
        it "should return true" do
          Fast::Dir.new.should_not exist :target
          Fast::Dir.new.should_not exist :demo
          
          Fast::File.new.touch "demo/some_conflict.txt"
          Fast::File.new.touch "target/some_conflict.txt"
          Fast::File.new.touch "target/not_at_all.txt"
          
          Fast::Dir.new.conflicts_with?(:demo, :target).should === true
        end
      end
    end

    context "recursive" do
      context "no file in any has the same path in the other" do
        it "should return false" do
          Fast::Dir.new.should_not exist :demo
          Fast::Dir.new.should_not exist :target
          
          Fast::File.new.touch "demo/some/file.txt"
          Fast::File.new.touch "demo/deep/in/the/tree.file"
          
          Fast::File.new.touch "target/no/conflict.what"
          Fast::File.new.touch "target/so/ever.txt"
          
          Fast::Dir.new.conflicts_with?(:demo, :target).should === false
        end      
      end
      
      context "at least one file in target dir have the same path as other in source" do
        it "should return true" do
          Fast::Dir.new.should_not exist :demo
          Fast::Dir.new.should_not exist :target
          
          Fast::File.new.touch "demo/some/file.txt"
          Fast::File.new.touch "demo/deep/in/the/tree.file"
          
          Fast::File.new.touch "target/some/file.txt"
          Fast::File.new.touch "target/so/ever.txt"
          
          Fast::Dir.new.conflicts_with?(:demo, :target).should === true
        end
      end
    end

    after do
      Fast::Dir.new.remove! :demo, :target
    end
  end
  
  describe "#[]" do
    before :each do
      Fast::Dir.new.should_not exist :demo
    end
    
    context "a file named like the argument exists" do
      it "should return it" do
        Fast::File.new.touch "demo/file.txt"
        
        the_file = Fast::Dir.new(:demo)["file.txt"]
        the_file.should be_a Fast::File
        the_file.path.should == "demo/file.txt"
      end
    end
    
    context "a dir named like the argument exists" do
      it "should return it" do
        Fast::Dir.new.create "demo/other_dir"
        the_dir = Fast::Dir.new(:demo)[:other_dir]
        the_dir.path.should == "demo/other_dir"
      end
    end
    
    context "an integer is sent" do
      it "should behave like an array" do
        Fast::File.new.touch "demo/file.txt"
        
        Fast::Dir.new.list(:demo)[0].should == "file.txt"
      end
    end
    
    context "there's nothing there" do
      it "should return nil" do
        Fast::Dir.new.create :demo
        Fast::Dir.new.list(:demo)[:no].should be_nil
      end
    end

    after :each do
      Fast::Dir.new.delete! :demo
    end
  end
  
  describe "#[]=" do # This is an absolute WIN
    before :each do 
      Fast::Dir.new.should_not exist :demo
    end
    
    context "the content is a String" do
      it "should create the file with the given content" do
        the_dir = Fast::Dir.new :demo # Showoff..
        the_dir[:Pianofile] = "set :port, 80" # So condensed, so solid
        Fast::File.new.read("demo/Pianofile").should == "set :port, 80"
      end
      
      it "should create self" do
        the_dir = Fast::Dir.new :demo # Showoff..
        the_dir[:Pianofile] = "set :port, 80" # So condensed, so solid
        Fast::Dir.new.should exist :demo
      end
    end
    
    context "the content is a hash" do
      it "should create the subdir" do
        the_dir = Fast::Dir.new :demo
        the_dir[:subdir] = {}
        Fast::Dir.new.should exist "demo/subdir"
      end
      
      it "should create files for each key pointing to a String" do
        the_dir = Fast::Dir.new :demo
        the_dir[:subdir] = { 
          "file.txt" => "The demo contents are awesome",
          "other.data" => "10101010001100011" }
        Fast::File.new.read( "demo/subdir/file.txt" ).should include "The demo contents are awesome"
        Fast::File.new.read( "demo/subdir/other.data" ).should include "10101010001100011"
      end
      
      it "should created directories for each key pointing to a Hash" do
        the_dir = Fast::Dir.new :demo
        the_dir[:subdir] = {
          :subsub => {},
          :data => {}
        }
        Fast::Dir.new.should exist "demo/subdir/subsub"
        Fast::Dir.new.should exist "demo/subdir/data"
      end
      
      it "should create recursively the tree" do
        the_dir = Fast::Dir.new :demo
        
        the_dir[:subdir] = {
          
          :subsub       => {
            :data       => {},
            "other.txt" => "More than this" 
          },
          
          "demo.txt"    => "Some file content" 
        }
          
        Fast::Dir.new.should exist "demo/subdir/subsub/data"
        Fast::File.new.read("demo/subdir/subsub/other.txt").should include "More than this"
        Fast::File.new.read("demo/subdir/demo.txt").should include "Some file content"
      end
      
      it "should handle conflicts somehow"
    end
    
    after :each do 
      Fast::Dir.new.delete! :demo
    end
  end
end
