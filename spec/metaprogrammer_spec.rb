RSpec.describe "Metaprogrammer" do

  context "class method usage" do

    it "patches class and instance methods" do
      Metaprogrammer.patch_all_methods(
        klass: @TestClass
      ) do |orig_method, *args, &blk|
        orig_method.call(*[:injected, *args], &blk)
      end
      args = [1, 2, 3, {foo: "bar"}]
      expect(
        @TestClass.foo(*args) { |*args| args }
      ).to eq [@TestClass, :injected, *args]
      expect(
        @TestClassInstance.foo(*args) { |*args| args }
      ).to eq [@TestClassInstance, :injected, *args]
    end

    it "only" do
      Metaprogrammer.patch_all_methods(
        klass: @TestClass,
        only: [:foo]
      ) do |orig_method, *args, &blk|
        orig_method.call(*[:injected, *args], &blk)
      end
      args = [1, 2, 3, {foo: "bar"}]
      expect(
        @TestClass.foo(*args) { |*args| args }
      ).to eq [@TestClass, :injected, *args]
      expect(
        @TestClassInstance.foo(*args) { |*args| args }
      ).to eq [@TestClassInstance, :injected, *args]
      expect(
        @TestClass.bar(*args) { |*args| args }
      ).to eq [@TestClass, *args]
      expect(
        @TestClassInstance.bar(*args) { |*args| args }
      ).to eq [@TestClassInstance, *args]
    end

    it "except" do
      Metaprogrammer.patch_all_methods(
        klass: @TestClass,
        except: [:foo]
      ) do |orig_method, *args, &blk|
        orig_method.call(*[:injected, *args], &blk)
      end
      args = [1, 2, 3, {foo: "bar"}]
      expect(
        @TestClass.bar(*args) { |*args| args }
      ).to eq [@TestClass, :injected, *args]
      expect(
        @TestClassInstance.bar(*args) { |*args| args }
      ).to eq [@TestClassInstance, :injected, *args]
      expect(
        @TestClass.foo(*args) { |*args| args }
      ).to eq [@TestClass, *args]
      expect(
        @TestClassInstance.foo(*args) { |*args| args }
      ).to eq [@TestClassInstance, *args]
    end

  end

  context "extended module usage" do

    it "patches class and instance methods" do
      @TestClass.patch_all_methods do |orig_method, *args, &blk|
        orig_method.call(*[:injected, *args], &blk)
      end
      args = [1, 2, 3, {foo: "bar"}]
      expect(
        @TestClass.foo(*args) { |*args| args }
      ).to eq [@TestClass, :injected, *args]
      expect(
        @TestClassInstance.foo(*args) { |*args| args }
      ).to eq [@TestClassInstance, :injected, *args]
    end

  end

end