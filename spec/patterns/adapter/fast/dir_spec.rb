require "fast"

describe Patterns::Adapter::Fast::Dir do
  describe "#symbols" do
    context "when given a list of file names" do
      it "should return a list of the same files as symbols without extensions" do
        list = ["file.txt", "data.txt", "thumbs.db", "data.txt.jpg"]
        final_list = Patterns::Adapter::Fast::Dir.new( list ).symbols
        final_list.should include :file
        final_list.should include :data
        final_list.should include :thumbs
        final_list.should include :"data.txt"
      end
    end
  end
end
