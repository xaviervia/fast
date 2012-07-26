module Patterns
  module Adapter
    module Fast
      class Dir
        def initialize source
          @source = source
        end
        
        def symbols
          return_me = []
          @source.each do |entry|
            return_me.push entry.gsub(/\.(\w+?)$/, "").to_sym
          end
          return return_me
        end
      end
    end
  end
end
