require "./test_helper"

class TestHash < Test::Unit::TestCase
  test "s_AREF" do
    assert { Hash[:a, 1 ,:b, 2] == {:a=>1, :b=>2} }
    assert { Hash[:a => 1, :b => 2] == {:a=>1, :b=>2} }
  end

  test "s_new" do
    assert { Hash.new == {} }
    assert { Hash.new("default")[:a] == "default" }
  end

  test "==" do
    assert { {:a => 1,:b => 2} == {:a => 1, :b => 2} }
    # hashだから順番は関係ない
    assert { {:a => 1,:b => 2} == {:b => 2, :a => 1} }
  end

  test "AREF" do
    assert { {:a => 1}[:a] == 1 }
  end

  test "ASET, store" do
    x = {}
    x[:a] = 1
    x.store(:b, 2)
    assert { x == {:a=>1, :b=>2} }
  end

  test "clear" do
    a = {:a => 1}
    a.clear
    assert { a == {} }
  end

  test "default" do
    assert { {}[:a] == nil }
    assert { {}.default == nil }
  end

  test "default_set" do
    x = {}
    x.default = "default"
    assert { x.default == "default" }
  end

  test "delete" do
    x = {:a => 1}
    assert { x.delete(:a) == 1 }
    assert { x.delete(:a) == nil }
    assert { x.delete(:a) { |e| e } == :a }
  end

  test "delete_if" do
    x = {:a => 1, :b => 2, :c => 3}
    assert { x.delete_if { |key, value| key >= :b } == {:a=>1} }
    # 常にselfを返す
    assert { x.delete_if { |key, value| false } == {:a=>1} }
  end

  test "reject!" do
    x = {:a => 1,:b => 2,:c => 3}
    assert { x.reject! { |key, value| key >= :b } == {:a=>1} }
    # ヒットしなければnil
    assert { x.reject! { |key, value| false } == nil }
  end

  test "reject" do
    x = {:a => 1,:b => 2,:c => 3}
    assert { x.reject { |key, value| key >= :b } == {:a=>1} }
    # selfは変更されていない
    assert { x == {:a=>1, :b=>2, :c=>3} }
  end

  test "each, each_pair" do
    assert { {:a => 1, :b => 2}.each.to_a == [[:a, 1], [:b, 2]] }
  end

  test "each_key" do
    assert { {:a => 1,:b => 2}.each_key.to_a == [:a, :b] }
  end

  test "value" do
    assert { {:a => 1,:b => 2}.each_value.to_a == [1, 2] }
  end

  test "empty?" do
    assert { {}.empty? == true }
  end

  test "fetch" do
    assert { {:a => 1}.fetch(:a) == 1 }
    assert { {:a => 1}.fetch(:b, 2) == 2 }
    assert { {:a => 1}.fetch(:b) { |e| e } == :b }
    assert_raise(KeyError) { {}.fetch(:a) }
  end

  test "has_key?" do            # include? key? menber?
    assert { {:a => 1}.has_key?(:a) == true }
  end

  test "has_value?" do          # value?
    assert { {:a => 1}.has_value?(1) == true }
  end

  test "indexes" do             # indices
    if RUBY_VERSION < "1.8"
      {:a => 1,:b => 2}.indexes(:a, :b, :c)
    end
  end

  test "values_at" do
    assert { {:a => 1, :b => 2}.values_at(:a,:b,:c) == [1, 2, nil] }
  end

  test "key" do
    assert { {:a => 1,:b => 2}.key(1) == :a }
  end

  test "invert" do
    assert { {:a => 1, :b => 2}.invert == {1=>:a, 2=>:b} }
  end

  test "keys" do
    assert { {:a => 1, :b => 2} == {:a=>1, :b=>2} }
  end

  test "length, size" do
    assert { {:a => 1, :b => 2}.length == 2 }
  end

  test "rehash" do
    a = [1]
    b = [2]
    x = { a => 1, b => 2}
    # キーに使っているオブジェクト内部を変更
    a[0] = 0
    # その為に参照に失敗した
    assert { x[a] == nil }
    x.rehash                    # 再構築すると
    # 参照可能になる
    assert { x[a] == 1 }
  end

  test "rehash_index_error" do
    x = {:a => 1}
    if RUBY_VERSION <= "1.6"
      assert_raises(IndexError){x.each{x.rehash}} # イテレータ内だとエラーになる
    end
    # イテレータ内だとエラーになる
    assert_raise(RuntimeError) { x.each { x.rehash } }
  end

  test "replace" do
    x = {}
    id = x.object_id
    x.replace({})
    assert { x.object_id == id }
  end

  test "shift" do
    x = {:a => 1}
    assert { x.shift == [:a, 1] }
    assert { x.shift == nil }
    assert { x == {} }
  end

  test "sort, sort_by" do
    x = {:c => 3, :a => 1, :b => 2}
    x.sort
    x.sort { |a, b| b[1] <=> a[1] }
    x.sort_by { |a| a[1] }
  end

  test "to_a" do
    {:a => 1,:b => 2}.to_a
  end

  test "to_s" do
    {:a => 1, :b => 2}.to_s
  end

  test "update" do
    v = {:a => 1}
    v.update(:b => 2)
    assert { v == {:a=>1, :b=>2} }
  end

  test "values" do
    {:a => 1, :b => 2}.values
  end
end
