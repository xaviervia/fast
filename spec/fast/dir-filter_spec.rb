require "fast"
require "zucker/os"

describe Fast::DirFilter do
  describe "#extension" do
    context "when given a list of file names and a extension" do
      it "should return a list of the files with the given extension"
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
