require "fast"
require "zucker/os"

# Just in case, delete the demo.txt
::File.unlink "demo.txt" if ::File.exist? "demo.txt"

describe Fast::File do
  describe "#append" do
    it "should create the file if it does not exist" do
      ::File.should_not exist "demo.txt"
      Fast::File.new.append "demo.txt", "some text"
      ::File.should exist "demo.txt"
      ::File.unlink "demo.txt"
    end
    
    it "should not erase the content of the file if it has some" do
      ::File.open "demo.txt", "w" do |file|
        file.write "some demo content"
      end
      
      Fast::File.new.append "demo.txt", "\nmore demo content"
      
      ::File.read( "demo.txt" ).should match /^some demo content/
      ::File.unlink "demo.txt"
    end
    
    it "should append the new content last in the file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "This comes first: "
      end
      Fast::File.new.append "demo.txt", "and this comes after."
      
      ::File.read( "demo.txt" ).should match /and this comes after.$/
      ::File.unlink "demo.txt"
    end
    
    it "should update the modification time" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Written earlier"
      end
      mtime = ::File.mtime "demo.txt"
      
      sleep 1
      Fast::File.new.append "demo.txt", "\nWritten later"
      ::File.mtime( "demo.txt" ).should > mtime
      
      ::File.unlink "demo.txt"
    end
    
    it "should return the file" do
      the_file = ::Fast::File.new.append "demo.file", "Some content."
      the_file.should be_a Fast::File
      the_file.delete!
    end
    
    it "should work even when a symbol is passed as argument" do
      Fast::File.new.append :demo_txt, "Hola."
      ::File.should exist "demo_txt"
      ::File.unlink "demo_txt"
    end

    context "the file is inside a non existing directory" do
      it "should create the directory aswell as the file" do
        ::File.should_not be_directory "demo"
        Fast::File.new.append "demo/demo.txt", "Nice content!"
        ::File.should be_directory "demo"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
  end
  
  describe "#<<" do
    it "should behave almost like #append"
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
  end
  
  describe "#delete" do
    before :each do @method = :delete end
    it_behaves_like "any file deletion" 
  end

  describe "#delete!" do
    before :each do @method = :delete! end
    it_behaves_like "any file deletion" 
  end
  
  describe "#unlink" do
    before :each do @method = :unlink end
    it_behaves_like "any file deletion"
  end
  
  describe "#del" do 
    before :each do @method = :del end
    it_behaves_like "any file deletion" 
  end
  
  describe "#destroy" do 
    before :each do @method = :destroy end
    it_behaves_like "any file deletion"
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
    
    it "should work with multiple arguments"
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
        it "should have direct access to file's methods"
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
  
  shared_examples_for "any file existencialism" do
    it "should return true if file exists" do
      ::File.should_not exist "demo.file"
      Fast::File.new.create! "demo.file"
      Fast::File.new.send( @method, "demo.file" ).should be_true
      Fast::File.new.delete "demo.file"
    end
    
    it "should return false if file does not exist" do
      ::File.should_not exist "demo.file"
      Fast::File.new.send( @method, "demo.file" ).should be_false
    end
    
    it "should return false if path represents a directory!"
  end
  
  describe "#exist?" do
    before :each do @method = :exist? end
    it_behaves_like "any file existencialism"
  end
  
  describe "#exists?" do
    before :each do @method = :exists? end
    it_behaves_like "any file existencialism"
  end
  
  describe "#exist_all?" do
    before :each do @method = :exist_all? end
    it_behaves_like "any file existencialism"
    
    it "should return true if all exist"
    
    it "should return false if any does not exist"
  end
  
  describe "#exist_any?" do
    before :each do @method = :exist_any? end
    it_behaves_like "any file existencialism"
    
    it "should return true if at least one exists"
    
    it "should return false if none exist"
  end
  
  shared_examples_for "any file subsetter" do
    # This is a reminder: along with Serializer, the Subsetter pattern
    # (and later, the Sorting one) should be implemented Fast
    
    # I guess filtering in Fast will be done in Fast::FileFilter
    it "should forward self to a filtering object" do      
      the_demo_file = Fast::File.new :demo
      Fast::FileFilter.should_receive( :new ).with the_demo_file
      the_demo_file.by
    end   
  end
  
  describe "#by" do 
    before :each do @method = :by end
    it_behaves_like "any file subsetter"
  end
  
  describe "#filter" do
    before :each do @method = :filter end
    it_behaves_like "any file subsetter"
  end

  describe ".new" do
    it "should accept a string path as argument" do
      Fast::File.new "demo"
    end
    
    it "should accept a symbol path as argument" do
      Fast::File.new :demo
    end
  end  

  shared_examples_for "any file absolutizer" do
    context "file path is a relative route" do
      it "should expand the file path with pwd" do
        Fast::File.new.send( @method, "demo.file" ).should == "#{Dir.pwd}/demo.file"
      end
    end
    
    context "file path is an absolute route" do
      it "should return the same as given path" do
        unless OS.windows?
          Fast::File.new.send( @method, "/dev/null" ).should == "/dev/null"
        else
          pending "POSIX only!"
        end
      end
    end
  end
  
  describe "#expand" do
    before :each do @method = :expand end
    it_behaves_like "any file absolutizer"
  end
  
  describe "#absolute" do
    before :each do @method = :absolute end
    it_behaves_like "any file absolutizer"
  end
 
  describe "#path" do 
    context "the path is setted" do
      it "returns the path" do
        the_file = Fast::File.new "demo.file"
        the_file.path.should == "demo.file"
      end
    end
    
    context "the path is undefined" do
      it "returns nil" do
        the_file = Fast::File.new
        the_file.path.should be_nil
      end
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
  
  describe "#merge" do
    it "should delete the target file"
    
    it "should append the contents of the target into this"
  end
end
