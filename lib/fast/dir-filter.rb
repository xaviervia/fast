module Fast
  # Specific filter for Dir entries. Should inherit or invoke a Generic Filter
  # Just a stub for the moment
  class DirFilter
    def initialize set
      @set = set
    end

    def extension the_extension
      return_me = []
      @set.each do |entry|
        return_me << entry if entry.end_with? the_extension
      end
      return_me
    end
  end
end
