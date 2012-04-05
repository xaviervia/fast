require "fast"
require "zucker/os"

describe SubSetter::Fast::Dir do
  describe "#extension" do
    context "when given a list of file names and a extension" do
      it "should return a Dir of the files with the given extension" do
        list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg"]
        final_list = SubSetter::Fast::Dir.new( list ).extension "txt"
        final_list.should be_a Fast::Dir
        final_list.should include "file.txt"
        final_list.should include "data.txt"
        final_list.should_not include "thumbs.db"
        final_list.should_not include "data.txt.jpg"
      end
    end
  end
  
  describe "#ending" do
    context "when given a list of file names and a ending" do 
      it "should return a Dir of the files with the given ending" do
        list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg"]
        final_list = SubSetter::Fast::Dir.new( list ).ending "txt"
        final_list.should be_a Fast::Dir
        final_list.should include "file.txt"
        final_list.should include "data.txt"
        final_list.should_not include "thumbs.db"
        final_list.should_not include "data.txt.jpg"
      end
    end
  end
  
  describe "#existence" do
    context "given a list of items some of which exist and some not" do
      it "should return only the existing ones"
    end
  end

  describe "#strip_extension" do
    it "should return a Dir with the files names without extension" do
      list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg", "noext"]
      final_list = SubSetter::Fast::Dir.new( list ).strip_extension
      final_list.should be_a Fast::Dir
      final_list.should include "file"
      final_list.should include "data"
      final_list.should include "thumbs"
      final_list.should include "data.txt"
      final_list.should include "noext"
    end
  end  
 
  describe "#match" do
    context "when given a list of strings and a regexp" do
      it "should return a Dir containing the strings that match the expression" do
        list = %w{is_a_file think_of_me not_my_file filesystem see_file_you}
        final_list = SubSetter::Fast::Dir.new( list ).match /file/
        final_list.should be_a Fast::Dir
        final_list.should include "is_a_file"
        final_list.should include "not_my_file"
        final_list.should include "filesystem"
        final_list.should include "see_file_you"
        final_list.should_not include "think_of_me"
      end
    end
  end
end
