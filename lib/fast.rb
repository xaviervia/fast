require "metafun/delegator"

require "fast/file"
require "fast/dir"
require "fast/dir-filter"
require "fast/file-filter"
require "fast/fast"

delegate Fast, :dir, :dir?, :dir!, :file, :file?, :file!
