


require "./test_helper"

require "pstore"
require "tempfile"

class TestPStore < Test::Unit::TestCase
  setup do
    @dbpath = "/tmp/pstore.db"
    File.delete(@dbpath) if File.exist?(@dbpath)
  end
  teardown do
    setup
  end
  test "s_new" do
    x = PStore.new(@dbpath)
    assert_instance_of(PStore, x)
  end
  test "AREF_ASET" do
    x = PStore.new(@dbpath)
    x.transaction {
      x['a']=1
      assert_equal(1, x['a'])	# 参照もこの中じゃないとダメ
    }
  end
  test "abort" do
    # 処理中にキャンセル
    x = PStore.new(@dbpath)
    x.transaction {x['a']=1; x.abort}

    # 前回の処理は破棄された為キーは存在しない
    x = PStore.new(@dbpath)
    x.transaction {
      assert_equal(false, x.root?('a'))
    }
  end
  test "commit" do		# ブロックが閉じる前に強制出力したい時に使用
    x = PStore.new(@dbpath)
    x.transaction {x['a']=1; x.commit}
  end
  test "path" do			# 覚えておくと便利
    x = PStore.new(@dbpath)
    assert_equal(@dbpath, x.path)
  end
  test "root?" do		# キーがあるか?
    x = PStore.new(@dbpath)
    x.transaction {
      x['a'] = 1
      assert_equal(true, x.root?('a'))
    }
  end
  test "roots" do
    x = PStore.new(@dbpath)
    x.transaction {
      x['a'] = 1
      x['b'] = 1
      assert_equal(['a','b'], x.roots)
    }
  end
  test "transaction" do
    PStore.new(@dbpath).transaction{|ps|
      # こうやって使った方が美しいかな
    }
  end
end
