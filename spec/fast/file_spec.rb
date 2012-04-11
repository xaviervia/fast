require "fast"
require "zucker/os"

# Just in case, delete the demo.txt
::File.unlink "demo.txt" if ::File.exist? "demo.txt"

describe Fast::File do
  shared_examples_for "any file content appending" do
    it "should create the file if it does not exist" do
      ::File.should_not exist "demo.txt"
      the_file = Fast::File.new "demo.txt"
      the_file.send @method, "some text"
      ::File.should exist "demo.txt"
      ::File.unlink "demo.txt"
    end

    it "should not erase the content of the file if it has some" do
      ::File.open "demo.txt", "w" do |file|
        file.write "some demo content"
      end
      
      the_file = Fast::File.new "demo.txt"
      the_file.send @method, "\nmore demo content"
      
      ::File.read( "demo.txt" ).should match /^some demo content/
      ::File.unlink "demo.txt"
    end

    it "should append the new content last in the file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "This comes first: "
      end
      the_file = Fast::File.new "demo.txt"
      the_file.send @method, "and this comes after."
      
      ::File.read( "demo.txt" ).should match /and this comes after.$/
      ::File.unlink "demo.txt"
    end

    it "should update the modification time" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Written earlier"
      end
      mtime = ::File.mtime "demo.txt"
      
      sleep 1
      the_file = Fast::File.new "demo.txt"
      the_file.send @method, "\nWritten later"
      ::File.mtime( "demo.txt" ).should > mtime
      
      ::File.unlink "demo.txt"
    end

    context "the file is inside a non existing directory" do
      it "should create the directory aswell as the file" do
        ::File.should_not be_directory "demo"
        the_file = Fast::File.new "demo/demo.txt"
        the_file.send @method, "Nice content!"
        ::File.should be_directory "demo"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
  end
  
  describe "#<<" do
    it_should_behave_like "any file content appending"
    before :all do @method = :"<<" end
  
    it "should fail if not path previously defined" do
      the_file = Fast::File.new
      expect { the_file << "More content"
      }.to raise_error "No path specified in the file"
    end
  end
  
  describe "#append" do
    it_should_behave_like "any file content appending"
    before :all do @method = :append end        
        
    it "should return the file" do
      the_file = ::Fast::File.new.append "demo.file", "Some content."
      the_file.should be_a Fast::File
      the_file.delete!
    end
  end
  
  describe "#write" do
    it "should create the file if it does not exist" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.write "demo.file", "This is all."
      Fast::File.new.should exist "demo.file"
      Fast::File.new.destroy "demo.file"
    end
    
    it "should write the given content into the file" do
      Fast::File.new.should_not exist "demo.file"
      the_file = Fast::File.new "demo.file"
      the_file.write "This is content!"
      the_file.read.should == "This is content!"
      the_file.destroy
    end
    
    it "should overwrite the file if it exists" do
      Fast::File.new.should_not exist "demo.file"
      ::File.open "demo.file", "w" do |file|
        file.write "Something..."
      end
      
      Fast::File.new.write "demo.file", "Another something"
      Fast::File.new.read( "demo.file" ).should == "Another something"
      Fast::File.new.delete! "demo.file"
    end
    
    it "should return the file" do
      the_file = Fast::File.new.write "demo.file", "More content this time."
      the_file.should be_a Fast::File
      the_file.delete!
    end
  end

  shared_examples_for "any file deletion" do
    it "should delete the file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.send @method, "demo.txt"
      ::File.should_not exist "demo.txt"
    end
    
    it "should return the path of the deleted file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.send( @method, "demo.txt" ).should == "demo.txt"
    end
    
    it "should be possible to use a symbol" do
      ::File.open "demo_txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.send @method, :demo_txt
      ::File.should_not exist "demo.txt"
    end
    
    it "should accept multiple arguments" do
      Fast::File.new.should_not exist "demo1.txt"
      Fast::File.new.should_not exist "demo2.txt"
      Fast::File.new.should_not exist "demo3.txt"
    
      Fast::File.new.touch "demo1.txt", "demo2.txt", "demo3.txt"
      
      Fast::File.new.send @method, "demo1.txt", "demo2.txt", "demo3.txt"
    end
  end
  
  describe "#delete" do
    before :each do @method = :delete end
    it_behaves_like "any file deletion" 
  end

  describe "#delete!" do
    before :each do @method = :delete! end
    it_behaves_like "any file deletion" 
    
    it "should not fail if the file does not exist" do
      Fast::File.new.should_not exist "the_file.txt"
      expect { Fast::File.new.delete! "the_file.txt"
      }.to_not raise_error
    end
  end
  
  describe "#unlink" do
    before :each do @method = :unlink end
    it_behaves_like "any file deletion"
  end

  describe "#unlink!" do
    before :each do @method = :unlink! end
    it_behaves_like "any file deletion" 
    
    it "should not fail if the file does not exist" do
      Fast::File.new.should_not exist "the_file.txt"
      expect { Fast::File.new.unlink! "the_file.txt"
      }.to_not raise_error
    end
  end
  
  describe "#del" do 
    before :each do @method = :del end
    it_behaves_like "any file deletion" 
  end
  
  describe "#del!" do
    before :each do @method = :del! end
    it_behaves_like "any file deletion" 
    
    it "should not fail if the file does not exist" do
      Fast::File.new.should_not exist "the_file.txt"
      expect { Fast::File.new.del! "the_file.txt"
      }.to_not raise_error
    end
  end

  describe "#destroy" do 
    before :each do @method = :destroy end
    it_behaves_like "any file deletion"
  end

  describe "#destroy!" do
    before :each do @method = :destroy! end
    it_behaves_like "any file deletion" 
    
    it "should not fail if the file does not exist" do
      Fast::File.new.should_not exist "the_file.txt"
      expect { Fast::File.new.destroy! "the_file.txt"
      }.to_not raise_error
    end
  end

  describe "#remove" do 
    before :each do @method = :remove end
    it_behaves_like "any file deletion"
  end

  describe "#remove!" do
    before :each do @method = :remove! end
    it_behaves_like "any file deletion" 
    
    it "should not fail if the file does not exist" do
      Fast::File.new.should_not exist "the_file.txt"
      expect { Fast::File.new.remove! "the_file.txt"
      }.to_not raise_error
    end
  end

  shared_examples_for "any file creation" do
    context "in current folder" do
      it "should create the file if it does not exist" do
        ::File.should_not exist "demo.txt"
        Fast::File.new.send @method, "demo.txt"
        ::File.should exist "demo.txt"
        ::File.unlink "demo.txt"
      end      
    end
    context "the file is inside a directory" do
      it "should create the file if it does not exist" do
        ::Dir.mkdir "demo" unless ::File.directory? "demo"
        ::File.should_not exist "demo/demo.txt"
        Fast::File.new.send @method, "demo/demo.txt"
        ::File.should exist "demo/demo.txt"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
    
    context "the file is inside several non existing directories" do
      it "should create all the required directory tree" do
        ::File.should_not be_directory "demo"
        Fast::File.new.send @method, "demo/in/several/subdirs/file.txt"
        ::File.should exist "demo/in/several/subdirs/file.txt"
        ::File.unlink "demo/in/several/subdirs/file.txt"
        ::Dir.unlink "demo/in/several/subdirs"
        ::Dir.unlink "demo/in/several"
        ::Dir.unlink "demo/in"
        ::Dir.unlink "demo"
      end   
    end
    
    context "the file is inside a non existing directory" do
      it "should create the directory aswell as the file" do
        ::File.should_not be_directory "demo"
        Fast::File.new.send @method, "demo/demo.txt"
        ::File.should exist "demo/demo.txt"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
    
    it "should not rise any error if the file already exists" do
      ::File.open "demo.txt", "w" do |file|
        file.write "something"
      end
      Fast::File.new.send @method, "demo.txt"
      ::File.unlink "demo.txt"
    end
    
    it "should be empty if it did not exist" do
      ::File.should_not exist "demo.txt"
      Fast::File.new.send @method, "demo.txt"
      ::File.read( "demo.txt" ).should == ""
      ::File.unlink "demo.txt"
    end
    
    it "should return the path to the file" do
      Fast::File.new.send( @method, "demo.txt" ).should == "demo.txt"
      ::File.unlink "demo.txt"
    end
    
    it "should accept a symbol as an argument" do
      Fast::File.new.send @method, :demo_txt
      ::File.unlink "demo_txt"
    end
    
    it "should work with multiple arguments" do
      Fast::File.new.should_not exist "demo1.txt" 
      Fast::File.new.should_not exist "demo2.txt" 
      Fast::File.new.should_not exist "demo3.txt"
      
      Fast::File.new.send @method, "demo1.txt", "demo2.txt", "demo3.txt"
      
      Fast::File.new.should exist "demo1.txt"
      Fast::File.new.should exist "demo2.txt"
      Fast::File.new.should exist "demo3.txt"
      
      Fast::File.new.delete "demo1.txt"
      Fast::File.new.delete "demo2.txt"
      Fast::File.new.delete "demo3.txt" 
    end
  end
  
  describe "#create" do
    before :each do @method = :create end
    it_behaves_like "any file creation"
  end
  
  describe "#create!" do 
    before :each do @method = :create! end
    it_behaves_like "any file creation"
  end
  
  describe "#touch" do
    before :each do @method = :touch end
    it_behaves_like "any file creation"
    
    it "should change its atime if already exists" do
      unless OS.windows?
        ::File.open "demo.txt", "w" do |file|
          file.write "Some content."
        end
        atime = ::File.atime "demo.txt"
        sleep 1
        Fast::File.new.touch "demo.txt"
        ::File.atime( "demo.txt" ).should > atime
        ::File.unlink "demo.txt"
      else
        pending "This is for POSIX only."
      end
    end
  end  
  
  describe "#read" do
    context "the file exists" do
      it "should return all the contents of the file" do
        ::File.should_not exist "demo.txt"
        Fast::File.new.append "demo.txt", "New content!"
        Fast::File.new.read( "demo.txt" ).should == "New content!"
        ::File.unlink "demo.txt"
      end
    
      it "should change the atime of the file" do
        ::File.should_not exist "demo.txt"
        Fast::File.new.append "demo.txt", "New content!"
        atime = ::File.atime "demo.txt"
        sleep 1
        Fast::File.new.read "demo.txt"
        ::File.atime("demo.txt").should > atime
        ::File.unlink "demo.txt"
      end
      
      it "should accept a symbol as an argument" do
        ::File.should_not exist "demo_txt"
        Fast::File.new.append "demo_txt", "New content!"
        Fast::File.new.read :demo_txt
        ::File.unlink "demo_txt"
      end
      
      context "a block is passed" do
        it "should have direct access to file's methods" do
          Fast::File.new.should_not exist :demo_txt
          Fast::File.new.append :demo_txt, "New content!"
          entered_the_block = false
          Fast::File.new.read :demo_txt do |the_file|
            the_file.should be_a ::File
            entered_the_block = true
          end
          entered_the_block.should be_true
          Fast::File.new.destroy! :demo_txt
        end
      end
    end
    
    context "the file doesn't exist" do
      it "should rise an exception" do
        ::File.should_not exist "demo.txt"
        expect { Fast::File.new.read "demo.txt"
        }.to raise_error
      end
    end
  end
  
  # Private method
  describe "#do_exist?" do
    context "it the file exist" do
      it "should return true" do
        ::File.should_not exist "demo.txt"
        Fast::File.new.create "demo.txt"
        file = Fast::File.new "demo.txt"
        def file.call_do_exist?
          do_exist? "demo.txt"
        end
        file.call_do_exist?.should === true
      end   

      after do
        Fast::File.new.destroy! "demo.txt"
      end
    end

    context "if the file does not exist" do
      it "should return false" do
        ::File.should_not exist "demo.txt"
        file = Fast::File.new "demo.txt"
        def file.call_do_exist?
          do_exist? "demo.txt"
        end
        file.call_do_exist?.should === false        
      end
    end
  end

  shared_examples_for "any file existencialism" do
    it "should return true if file exists" do
      pending "move partially to FilesystemObject"
      ::File.should_not exist "demo.file"
      Fast::File.new.create! "demo.file"
      Fast::File.new.send( @method, "demo.file" ).should be_true
      Fast::File.new.delete "demo.file"
    end
    
    it "should return false if file does not exist" do
      pending "move partially to FilesystemObject"
      ::File.should_not exist "demo.file"
      Fast::File.new.send( @method, "demo.file" ).should be_false
    end
    
    it "should return false if path represents a directory!" do
      pending "move partially to FilesystemObject"
      Fast::Dir.new.should_not exist "demo"
      Fast::Dir.new.create "demo"
      Fast::File.new.send( @method, "demo" ).should be_false
      Fast::Dir.new.delete "demo"
    end
  end  
  
  describe "#exist_all?" do
    before :each do @method = :exist_all? end
    it_behaves_like "any file existencialism"
    
    it "should return true if all exist" do
      pending "Method being moved to Fast::FilesystemObject"
      # Create the demo files
      Fast::File.new.touch "demo1.txt", "demo2.txt", "demo3.txt"
      
      # Try it
      Fast::File.new.exist_all?("demo1.txt", "demo2.txt", "demo3.txt").should be_true
    end
    
    it "should return false if any does not exist" do
      pending "Method being moved to Fast::FilesystemObject"
      Fast::File.new.touch "demo1.txt", "demo2.txt", "demo3.txt"
      Fast::File.new.should_not exist "demo4.txt"
      
      Fast::File.new.exist_all?("demo2.txt", "demo4.txt", "demo1.txt").should be_false
    end
  
    after :all do
      # Clean after deeds
      Fast::File.new.delete! "demo1.txt"
      Fast::File.new.delete! "demo2.txt"
      Fast::File.new.delete! "demo3.txt"
    end
  end
  
  describe "#exist_any?" do
    before :each do @method = :exist_any? end
    it_behaves_like "any file existencialism"
    
    it "should return true if at least one exists" do
      pending "Method being moved to Fast::FilesystemObject"
      Fast::File.new.touch "demo1.txt"
      Fast::File.new.should_not exist "demo2.txt"
      
      Fast::File.new.exist_any?("demo1.txt", "demo2.txt").should be_true
    end
    
    it "should return false if none exist" do
      pending "Method being moved to Fast::FilesystemObject"
      Fast::File.new.should_not exist "demo2.txt"
      Fast::File.new.should_not exist "demo3.txt"
      
      Fast::File.new.exist_any?("demo2.txt", "demo3.txt").should be_false
    end
    
    after :all do 
      Fast::File.new.delete "demo1.txt"
    end
  end
  
  describe "#exist_which" do
    it "should return a list with the files that exist" do
      pending "Method being moved to Fast::FilesystemObject"
      Fast::File.new.should_not exist "demo1.txt"
      Fast::File.new.should_not exist "demo2.txt"
      Fast::File.new.should_not exist "demo3.txt"

      Fast::File.new.touch "demo1.txt", "demo2.txt"
      the_files = Fast::File.new.exist_which "demo1.txt", "demo2.txt", "demo3.txt"
      the_files.should include "demo1.txt"
      the_files.should include "demo2.txt"
      the_files.should_not include "demo3.txt"      
    end

    after :all do
      Fast::File.new.delete "demo1.txt"
      Fast::File.new.delete "demo2.txt"
    end
  end
  
  describe "#empty?" do
    it "should return true if the file has no content" do
      Fast::File.new.should_not exist "demo.txt"
      Fast::File.new.touch "demo.txt"
      
      Fast::File.new.empty?("demo.txt").should be_true
    end
    
    it "should return true if the file does not exist" do
      Fast::File.new.should_not exist "demo.txt"
      
      Fast::File.new.empty?("demo.txt").should be_true
    end
    
    it "should return false if the file has content" do
      Fast::File.new.should_not exist "demo.txt"
      Fast::File.new.write "demo.txt", "Some irrelevant content."
      
      Fast::File.new.empty?("demo.txt").should be_false
    end
    
    after :each do 
      Fast::File.new.delete! "demo.txt"
    end
  end

  describe ".new" do
    it "should accept a string path as argument" do
      Fast::File.new "demo"
    end
    
    it "should accept a symbol path as argument" do
      Fast::File.new :demo
    end
  end  

  shared_examples_for "any file renaming" do
    it "should change the file's name" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should_not exist "renamed.file"
      Fast::File.new.write "demo.file", "This content is the proof."
      Fast::File.new.send @method, "demo.file", "renamed.file"
      
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should exist "renamed.file"
      Fast::File.new.read( "renamed.file" ).should == "This content is the proof."
      Fast::File.new.delete! "renamed.file"
    end
  end

  describe "#rename" do
    before :all do @method = :rename end
    it_behaves_like "any file renaming"
    
    it "should fail if a file named as the new name exists" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should_not exist "renamed.file"
      Fast::File.new.touch "renamed.file"
      Fast::File.new.write "demo.file", "Demo content bores me"
      
      expect { Fast::File.new.rename "demo.file", "renamed.file"
      }.to raise_error ArgumentError, "The file 'renamed.file' already exists"
      
      Fast::File.new.delete! "demo.file"
      Fast::File.new.delete! "renamed.file"
    end
  end
  
  describe "#rename!" do
    before :all do @method = :rename! end
    it_behaves_like "any file renaming"

    it "should overwrite the new file if it exists" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should_not exist "renamed.file"
      Fast::File.new.touch "renamed.file"
      Fast::File.new.write "demo.file", "Demo content bores me"
      
      Fast::File.new.rename! "demo.file", "renamed.file"
      
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.read( "renamed.file" ).should == "Demo content bores me"
      
      Fast::File.new.delete! "renamed.file"
    end
  end
  
  describe "#move" do
    before :all do @method = :move end
    it_behaves_like "any file renaming"
    
    it "should fail if a file named as the new name exists" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should_not exist "renamed.file"
      Fast::File.new.touch "renamed.file"
      Fast::File.new.write "demo.file", "Demo content bores me"
      
      expect { Fast::File.new.move "demo.file", "renamed.file"
      }.to raise_error ArgumentError, "The file 'renamed.file' already exists"
      
      Fast::File.new.delete! "demo.file"
      Fast::File.new.delete! "renamed.file"
    end
  end
  
  describe "#move!" do
    before :all do @method = :move! end
    it_behaves_like "any file renaming"

    it "should overwrite the new file if it exists" do
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.should_not exist "renamed.file"
      Fast::File.new.touch "renamed.file"
      Fast::File.new.write "demo.file", "Demo content bores me"
      
      Fast::File.new.move! "demo.file", "renamed.file"
      
      Fast::File.new.should_not exist "demo.file"
      Fast::File.new.read( "renamed.file" ).should == "Demo content bores me"
      
      Fast::File.new.delete! "renamed.file"
    end
  end
  
  describe "#merge" do
    before :each do
      Fast::File.new.should_not exist "demo.txt"
      Fast::File.new.should_not exist "target.txt"
      
      Fast::File.new.write "demo.txt", "Basic content"
      Fast::File.new.write "target.txt", "\nSome extra content"
    end

    it "should delete the target file" do      
      Fast::File.new.merge "demo.txt", "target.txt"
      
      Fast::File.new.should_not exist "target.txt"
      Fast::File.new.should exist "demo.txt"
    end
    
    it "should append the contents of the target into this" do
      Fast::File.new.merge "demo.txt", "target.txt"
      
      Fast::File.new.read("demo.txt").should include "Basic content\nSome extra content"
    end
    
    it "should return self" do
      the_file = Fast::File.new "demo.txt"
      the_file.merge("target.txt").should be the_file
    end
    
    context "some is missing" do
      it "should fail if self is missing" do 
        expect { Fast::File.new.merge "hola.txt", "target.txt"
        }.to raise_error Errno::ENOENT
      end
      
      it "should fail if target is missing" do
        expect { Fast::File.new.merge "demo.txt", "hola.txt"
        }.to raise_error Errno::ENOENT
      end
    end
    
    after :each do
      Fast::File.new.delete! "demo.txt"
      Fast::File.new.delete! "target.txt"
    end
  end

  shared_examples_for "any file copying" do
    before :each do 
      Fast::File.new.should_not exist "demo.txt"
      Fast::File.new.write "demo.txt", "Need for content"
    end
    
    it "should exist the target file after the copy" do
      Fast::File.new.send @method, "demo.txt", "target.txt"
      
      Fast::File.new.should exist "target.txt"
    end
    
    it "should exist the source file after the copy" do
      Fast::File.new.send @method, "demo.txt", "target.txt"
      
      Fast::File.new.should exist "demo.txt"      
    end
    
    it "should contain the same content both the source and the target files" do
      Fast::File.new.send @method, "demo.txt", "target.txt"
      
      Fast::File.new.read("demo.txt").should == Fast::File.new.read("target.txt")
    end
    
    after :each do 
      Fast::File.new.delete! "demo.txt"
      Fast::File.new.delete! "target.txt"
    end
  end
  
  describe "#copy" do
    it_behaves_like "any file copying"
    before :all do @method = :copy end
    
    context "the target file exists" do
      it "should fail" do
        Fast::File.new.should_not exist "demo.txt"
        Fast::File.new.should_not exist "target.txt"
        Fast::File.new.write "demo.txt", "Once upon a time."
        Fast::File.new.write "target.txt", "A hobbit there was."
        
        expect { Fast::File.new.copy "demo.txt", "target.txt"
        }.to raise_error ArgumentError, "Target 'target.txt' already exists."
        
        Fast::File.new.delete! "demo.txt"
        Fast::File.new.delete! "target.txt"
      end
    end
  end
  
  describe "#copy!" do
    it_behaves_like "any file copying"
    before :all do @method = :copy! end
    
    context "the target file exists" do
      it "should overwrite the target file" do
        Fast::File.new.should_not exist "demo.txt"
        Fast::File.new.should_not exist "target.txt"
        Fast::File.new.write "demo.txt", "Once upon a time."
        Fast::File.new.write "target.txt", "A hobbit there was."
        
        Fast::File.new.copy! "demo.txt", "target.txt"
        Fast::File.new.read("demo.txt").should == Fast::File.new.read("target.txt")
        
        Fast::File.new.delete! "demo.txt"
        Fast::File.new.delete! "target.txt"        
      end
    end
  end
end
