Fast
==== 

[![Build Status](https://secure.travis-ci.org/xaviervia/fast.png)](http://travis-ci.org/xaviervia/fast)

Tired of having a hard time working with files? Take a look at Fast...

    require "fast"
    
    lib_dir = dir! :lib # Creates a new dir "lib"
    
    lib_dir["demo.txt"] = "I love creating files from a Hash-like API"  
      # Creates lib/demo.txt containing the text
    
    lib_dir.list  # => ['demo.txt']
    
    file! "lib/empty.txt" # New file lib/empty.txt
    
    lib_dir.files do |path|
      puts path
    end # => demo.txt
        #    empty.txt
  
    lib_dir.destroy
    
    dir? :lib     # => false

...and finally is **quite stable** so you can use it if you wish so.

Fast is a DSL for file and dir handling focused in intuitivity and semantics. Fast is pure Ruby, don't relays on OS functions, so is a little slower but more portable.

== Installation

    gem install fast

== Usage

Fast declares two sets of methods in its DSL:

=== Dir methods

    dir :lib                # The same as => Fast::Dir.new "lib"
    dir.delete! "demo"      # The same as => Fast::Dir.new.delete! "demo"
  
    dir! :new_dir           # The same as => Fast::Dir.new.create! :new_dir
    dir? :new_dir           # The same as => Fast::Dir.new.exist? :new_dir
  
=== File methods

    file "demo.txt"         # The same as => Fast::File.new "demo.txt"
    file.copy "demo.txt", "new.txt"  # The same as =>
                          # Fast::File.new.copy "demo.txt", "new.txt"
                          
    file! "demo.txt"        # The same as => Fast::File.new.create! "demo.txt"
    file? "demo.txt"        # The same as => Fast::File.new.exist? "demo.txt"

== Philosophy

*Fast* embraces the more straightforward view of files as strings of data and directories as arrays of files/directories. Why?

* It is more realistic in everyday usage
* It makes them more object-like (and thus, more friendly to OOP)
* It is more semantic
* Files as IOs are still accessible through the harder-to-use native Ruby API

<tt>Fast::Dir</tt> is a subclass of <tt>Array</tt>, usable as a hash, and <tt>Fast::File</tt> if a subclass of String.

== Conflicts

It is a known issue that the DSL of Fast conflicts with [Pry][pry-gem] and most notable with [Rake][rake-gem]; I am aware that is a bold move to reclaim `file` from the standard namespace for Fast to use.

In order to workaround that, you can require fast in a not-so-much DSL way:

    require "fast/fast"
    
    Fast.file "myfile.txt" # The same as `file "myfile.txt"`
    
    Fast.dir! :lib # etc...

This is also the recommended form when using Fast in the context of a library. 

> Also: try to avoid using Fast in a library, because Fast is mostly semantic sugar and you want to avoid adding loading time just for the sake of having a couple of convenience methods. Fast is more fun when used for code sketching and simple scripts.

[pry-gem]: https://github.com/pry/pry
[rake-gem]: http://rake.rubyforge.org/

== Quick notes

* Remember to develop the SubSetter pattern in its own gem.

* Rename FilesystemObject: Item, CommonMethods, AbstractFile, FastHelpers (think!)
* Deliberate whether is a good idea to make Fast::Dir and Fast::File Multitons. (May be only when an absolute path is used)
* The path can be setted indirectly by any method of Fast::File instances, and the same works for Dir. This is fine because allows for very quick calls, but once an instance gets a path setted it should be fixed and raise an exception in case some other method call is trying to change it.

=== Fast::File
* Read bytes as binary ASCII-8BIT always and then try to perform an heuristic conversion, if there is any reasonable way to do it. Otherwise, leave it to the user. Google: "ruby string encode utf-8 ascii" for some good readings.

=== Fast::Dir
* Calls to #dirs and #files should delegate to a SubSetter
* Change the behaviour in the calls to #dirs and #files: return a new instance, with no @path setted.
* Change the behaviour in the initialization: call list always if there's a path an the path matches an existing directory
* Allow for easy recursive calls (#list_all, #files_all, #dirs_all for example)
* Deliberate whether "#<<" should be kept in Fast::Dir and if it should be use as alias for merge
* An instance of Fast::Dir should be possible to be created from a Array. (pity I didn't specified an usage case) 

== Remote future
* Make Fast a REST client (well, use <tt>rest-client</tt>) in order to transparently use files and directories from a compliant REST server. 
* Include REST methods: Dir#post, File#get, File#head, etc
* Allow Files to behave as Dirs with the right method calls

== License

GPL License. Why other?

@ Xavier Via
