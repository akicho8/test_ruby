require "./test_helper"

class TestFixnum < Test::Unit::TestCase
  test "Fixnum はもう古い？" do
    # Fixnum
    # 参照するだけで警告がでる
  end

  test "s_superclass" do
    # assert { Fixnum.superclass == Numeric }
  end

  test "AREF" do
    assert { 4.times.collect { |i| 10[i] } == [0, 1, 0, 1] }
  end

  test "to_i" do
   assert { 123.to_i == 123 }
  end

  test "to_s" do
    assert { 123.to_s == "123" }
  end

  test "to_f" do
    assert_in_delta 123.0, 123.to_f, 0.0001
  end

  test "size" do
    assert { 0.size == 8 }
    assert { 256.size == 8 }
    assert { 65536.size == 8 }
    assert { 10000000000.size == 8 }
    assert { 100000000000000000000.size == 9 }
    assert { 10000000000000000000000000000000.size == 13 }
    assert { 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.size == 37 }
  end
end
