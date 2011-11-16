require "metafun/delegator"

require "fast/file"
require "fast/dir"
require "fast/dir-filter"
require "fast/file-filter"
require "fast/fast"

#include Metafun::Delegator

#delegate Fast, :dir, :dir?, :dir!, :file, :file?, :file!
