require "metafun/delegator"

require "fast/file"
require "fast/dir"
require "fast/fast"

delegate Fast, :dir, :dir?, :dir!, :file, :file?, :file!
