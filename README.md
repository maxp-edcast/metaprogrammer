## Metaprogrammer

---

### Install

Install from rubygems, the gem is named 'metaprogrammer'.

### Usage

`Metaprogrammer` is a module. There are two main methods it exposes:

- `patch_class_methods`
- `patch_instance_methods`.

There is also a `patch_all_methods` method that has the same signature
as the other two, and calls them both.

An example usage looks like this:

```
class MyClass
  extend Metaprogrammer
  def foo
    1
  end
  def self.foo
    1
  end
end

MyClass.patch_all_methods do |orig_method, **args, &blk|
  orig_method.call(**args, &blk) + 1
end

MyClass.foo # => 2
MyClass.new.foo # => 2
```

You can manipulate the arguments or the return value.

A couple example usages are included with the gem:

```
# Rescue all errors
MyClass.rescue_all_methods(RuntimeError) do |error|
  puts "#{error.class} was raised!"
end

# Memoize all methods
MyClass.memoize # memoizes all methods.
```

The implementations of these methods are pretty simple
(assuming these are called in class scope of the method which extends Metaprogrammer)

```
# rescue all methods
patch_all_methods do |orig_method, *args, &caller_blk|
  begin
    orig_method.call *args, &caller_blk
  rescue *exceptions => e
    blk.call(e)
  end
end

# memoize methods
patch_all_methods do |orig_method, *args, &caller_blk|
  memos = @_memoized_methods ||= {}
  method_memos = @_memoized_methods[orig_method] ||= {}
  method_memos[args] ||= orig_method.call *args, &caller_blk
end
```

`patch_all_methods`, `patch_class_methods`, and `patch_instance_methods` can all
be configured with `only:` and `except:` options. These should be given
as arrays of symbols corresponding to method names.
