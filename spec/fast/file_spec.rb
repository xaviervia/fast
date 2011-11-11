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
    
    it "should return the path to the file" do
      Fast::File.new.append( "demo.txt", "Hola." ).should == "demo.txt"
      ::File.unlink "demo.txt" 
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
  

  shared_examples_for "any deletion" do
    it "should delete the file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.delete "demo.txt"
      ::File.should_not exist "demo.txt"
    end
    
    it "should return the path of the deleted file" do
      ::File.open "demo.txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.delete( "demo.txt" ).should == "demo.txt"
    end
    
    it "should be possible to use a symbol" do
      ::File.open "demo_txt", "w" do |file|
        file.write "Hola."
      end
      
      Fast::File.new.delete :demo_txt
      ::File.should_not exist "demo.txt"
    end
  end
  
  describe "#delete" do it_behaves_like "any deletion" end
  describe "#unlink" do it_behaves_like "any deletion" end
  describe "#del" do it_behaves_like "any deletion" end
  describe "#destroy" do it_behaves_like "any deletion" end
  
  describe "#touch" do
    context "in current folder" do
      it "should create the file if it does not exist" do
        ::File.should_not exist "demo.txt"
        Fast::File.new.touch "demo.txt"
        ::File.should exist "demo.txt"
        ::File.unlink "demo.txt"
      end
      
    end
    
    context "the file is inside a directory" do
      it "should create the file if it does not exist" do
        ::Dir.mkdir "demo" unless ::File.directory? "demo"
        ::File.should_not exist "demo/demo.txt"
        Fast::File.new.touch "demo/demo.txt"
        ::File.should exist "demo/demo.txt"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
    
    context "the file is inside a non existing directory" do
      it "should create the directory aswell as the file" do
        ::File.should_not be_directory "demo"
        Fast::File.new.touch "demo/demo.txt"
        ::File.should exist "demo/demo.txt"
        ::File.unlink "demo/demo.txt"
        ::Dir.unlink "demo"
      end
    end
    
    it "should not rise any error if the file already exists" do
      ::File.open "demo.txt", "w" do |file|
        file.write "something"
      end
      Fast::File.new.touch "demo.txt"
      ::File.unlink "demo.txt"
    end
    
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

    it "should be empty if it did not exist" do
      ::File.should_not exist "demo.txt"
      Fast::File.new.touch "demo.txt"
      ::File.read( "demo.txt" ).should == ""
      ::File.unlink "demo.txt"
    end
    
    it "should return the path to the file" do
      Fast::File.new.touch( "demo.txt" ).should == "demo.txt"
      ::File.unlink "demo.txt"
    end
    
    it "should accept a symbol as an argument" do
      Fast::File.new.touch :demo_txt
      ::File.unlink "demo_txt"
    end
  end  
end
