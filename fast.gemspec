# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fast/version"

Gem::Specification.new do |s|
  s.name        = "fast"
  s.version     = Fast::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Xavier Via"]
  s.email       = ["xavierviacanel@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{DSL for file system interaction}
  s.description = %q{DSL for file system interaction}

  s.rubyforge_project = "fast"
  
  s.add_dependency "metafun"
  
  s.add_development_dependency "rspec"
  s.add_development_dependency "zucker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
