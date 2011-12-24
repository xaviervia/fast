module SubSetter
  module Fast
    # Specific subsetter for Dir entries. Should inherit or invoke the SubSetter::Array
    # Just a stub for the moment
    class Dir
      def initialize set
        @set = set
      end

      def extension the_extension
        return_me = ::Fast::Dir.new
        @set.each do |entry|
          return_me << entry if entry.end_with? the_extension
        end
        return_me
      end
      
      def strip_extension
        return_me = ::Fast::Dir.new
        @set.each do |entry|
          return_me.push entry.gsub /\.(\w+?)$/, ""
        end
        return_me
      end
      
      def match regexp
        return_me = ::Fast::Dir.new
        @set.each do |entry|
          return_me << entry if entry.match regexp
        end
        return_me
      end
    end
  end
end
