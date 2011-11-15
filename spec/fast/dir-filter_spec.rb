require "fast"
require "zucker/os"

describe Fast::DirFilter do
  describe "#extension" do
    context "when given a list of file names and a extension" do
      it "should return a Dir of the files with the given extension" do
        list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg"]
        final_list = Fast::DirFilter.new( list ).extension "txt"
        final_list.should be_a Fast::Dir
        final_list.should include "file.txt"
        final_list.should include "data.txt"
        final_list.should_not include "thumbs.db"
        final_list.should_not include "data.txt.jpg"
      end
    end
  end

  describe "#strip_extension" do
    it "should return a Dir with the files names without extension" do
      list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg", "noext"]
      final_list = Fast::DirFilter.new( list ).strip_extension
      final_list.should be_a Fast::Dir
      final_list.should include "file"
      final_list.should include "data"
      final_list.should include "thumbs"
      final_list.should include "data.txt"
      final_list.should include "noext"
    end
  end  

  # VERY IMPORTANT: DirFilter should extend a class ListFilter
  # #match implementation (along with a short list of other things) should
  # be done in ListFilter, not in DirFilter
  #
  # The SubSetter pattern is still not defined nor implemented: I'll start by
  # finishing Fast and after that I'll dig deeper into SubSetting 
  describe "#match" do
    context "when given a list of strings and a regexp" do
      it "should return a list containing the strings that match the expression"
    end
  end
end
