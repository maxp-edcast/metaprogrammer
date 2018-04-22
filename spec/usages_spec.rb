RSpec.describe "Usages" do

  it "rescue_all_methods" do
    errors = [ArgumentError, RuntimeError]
    @TestClass.class_exec do
      def test_rescue
        raise ArgumentError
      end
      def self.test_rescue
        raise RuntimeError
      end
    end
    @TestClass.rescue_all_methods(*errors) do |error|
      "#{error.class} raised"
    end
    expect(@TestClass.test_rescue).to eq "RuntimeError raised"
    expect(@TestClassInstance.test_rescue).to eq "ArgumentError raised"
  end

  it 'memoize' do
    @TestClass.class_exec do
      def memoized
        rand(1e9)
      end
      def self.memoized
        rand(1e9)
      end
    end
    @TestClass.memoize
    [@TestClass, @TestClassInstance].each do |obj|
      expect(3.times.map { obj.memoized }.uniq.length).to eq(1)
    end
  end

end
