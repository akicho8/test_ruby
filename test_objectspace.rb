require "./test_helper"

class TestObjectSpace < Test::Unit::TestCase
  test "_id2ref" do             # id => object 変換
    x = "a"
    assert_equal(x.object_id, ObjectSpace._id2ref(x.object_id).object_id)
  end

  test "define_finalizer" do
    x = "a"
    ObjectSpace.define_finalizer(x, lambda{}) # デストラクタ相当(複数登録可能)
    x = nil
    ObjectSpace.garbage_collect # GC実行
  end

  test "undefine_finalizer" do
    x = "a"
    ObjectSpace.define_finalizer(x, lambda{puts "BYE"})
    ObjectSpace.undefine_finalizer(x) # ここで解除したので BYE は表示されない
    x = nil
    ObjectSpace.garbage_collect # GC実行
  end

  test "each_object" do
    assert_equal(true, ObjectSpace.each_object(Array){} >= 1) # Arrayのサブクラスの数を返す
    assert_equal(true, ObjectSpace.each_object{|e|} >= 1) # 全てのオブジェクトを操作して数を返す
  end
end
