
# =========================================
# CUSTOM REQUIRES:
# =========================================

require_relative "../lib/metaprogrammer.rb"

RSpec.configure do |config|

  # =========================================
  # CUSTOM CALLBACKS
  # =========================================

  config.before(:each) do
    @TestClass = Class.new do
      extend Metaprogrammer
      def self.foo(arg, *args, **opts, &blk)
        blk.call self, arg, *args, **opts
      end
      def foo(arg, *args, **opts, &blk)
        blk.call self, arg, *args, **opts
      end
      def self.bar(arg, *args, **opts, &blk)
        blk.call self, arg, *args, **opts
      end
      def bar(arg, *args, **opts, &blk)
        blk.call self, arg, *args, **opts
      end
    end
    @TestClassInstance = @TestClass.new
  end

  # =========================================
  # DEFAULT STUFF:
  # =========================================

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
