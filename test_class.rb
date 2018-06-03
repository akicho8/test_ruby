require "./test_helper"

# class A
#   def foo2
#     foo
#   end

#   private
#   def foo
#     1
#   end
# end

# module B
#   def self.included(mod)
#     mod.class_eval{
#       alias :_foo :foo
#       # remove_method :foo
#     }
#   end
#   def foo
#     2 + super
#   end
# end

# class A
#   include B
# end

# p A.ancestors
# p A.new.foo2
# exit

class Class
  alias old_new new
  def new(*args, &block)
    # p "Creating #{self}"
    old_new(*args, &block)
  end
end

class TestClassTop
  SUB_CLASSES = []
  def self.inherited(sub)       # 継承したら呼ばれる(引数は継承先)
    SUB_CLASSES << sub
  end
end

class TestClassSub1 < TestClassTop
end
class TestClassSub1 < TestClassTop
end
class TestClassSub2 < TestClassTop
end

class TestClass < Test::Unit::TestCase
  test "superclass" do
    assert_equal(Module, Class.superclass)
  end

  test "constants" do
    assert_equal(true, Class.constants.include?("TestClass"))
  end

  test "inherited" do
    assert_equal([TestClassSub1, TestClassSub2], TestClassTop::SUB_CLASSES)
  end

  test "new" do
    x = Class.new
    assert_equal(Object, x.superclass)
    x = Class.new(Array)
    assert_equal(Array, x.superclass)
  end
end
# >> Loaded suite -
# >> Started
# >> F
# >> ===============================================================================
# >> Failure: test: constants(TestClass)
# >> -:62:in `block in <class:TestClass>'
# >> <true> expected but was
# >> <false>
# >> 
# >> diff:
# >> ? tru e
# >> ? fals 
# >> ===============================================================================
# >> ...
# >> Finished in 0.012005 seconds.
# >> -------------------------------------------------------------------------------
# >> 4 tests, 5 assertions, 1 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 75% passed
# >> -------------------------------------------------------------------------------
# >> 333.19 tests/s, 416.49 assertions/s
