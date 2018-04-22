require 'pry'
module Metaprogrammer

  module Core

    def patch_all_methods(klass: self, **opts, &blk)
      patch_class_methods(klass: klass, **opts, &blk)
      patch_instance_methods(klass: klass, **opts, &blk)
    end

    def patch_class_methods(klass: self, **opts, &blk)
      all_fns = (
        [klass] | (klass.ancestors - Object.ancestors)
      ).flat_map do |klass_x|
        klass_x.methods(false)
      end
      fns = Metaprogrammer.filter_methods all_fns, **opts
      fns.each do |fn_name|
        orig_method = klass.method fn_name
        klass.singleton_class.send(:define_method, fn_name) do |*args, &caller_blk|
          blk.call orig_method, *args, &caller_blk
        end
      end
    end

    def patch_instance_methods(klass: self, **opts, &blk)
      all_fns = (
        [klass] | (klass.ancestors - Object.ancestors)
      ).flat_map do |klass_x|
        klass_x.instance_methods(false)
      end
      fns = Metaprogrammer.filter_methods all_fns, **opts
      fns.each do |fn_name|
        orig_method = klass.instance_method fn_name
        klass.send(:define_method, fn_name) do |*args, &caller_blk|
          blk.call orig_method.bind(self), *args, &caller_blk
        end
      end
    end

  end

  include Core

  require_relative 'metaprogrammer/usages'

  include Usages

  def self.filter_methods(fns, only: nil, except: nil)
    if only
      only = Set.new(only)
      fns = fns.select(&only.method(:member?))
    end
    if except
      except = Set.new(except)
      fns = fns.reject(&except.method(:member?))
    end
    fns
  end

  extend Metaprogrammer

end
