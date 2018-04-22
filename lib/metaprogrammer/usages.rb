module Metaprogrammer
  module Usages

    def rescue_all_methods(*exceptions, klass: self, **opts, &blk)
      patch_all_methods(klass: klass, **opts) do |orig_method, *args, &caller_blk|
        begin
          orig_method.call *args, &caller_blk
        rescue *exceptions => e
          blk.call(e)
        end
      end
    end

    def memoize(klass: self, **opts, &blk)
      patch_all_methods(klass: klass, **opts) do |orig_method, *args, &caller_blk|
        memos = @_memoized_methods ||= {}
        method_memos = @_memoized_methods[orig_method] ||= {}
        method_memos[args] ||= orig_method.call *args, &caller_blk
      end
    end

  end
end