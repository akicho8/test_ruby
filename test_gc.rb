require "./test_helper"

# https://docs.ruby-lang.org/ja/latest/class/GC.html
class TestGC < Test::Unit::TestCase
  include GC             # これで garbage_collect が使えるようになる

  # GC実行回数
  test ".count" do
    assert { GC.count.kind_of?(Integer) }
  end

  # 有効化 / 無効化
  test ".enable .disable" do
    assert { GC.disable == false } # 戻値は前回のdisableの状態でdisableしていたらtrueという真偽が想像と逆なのでわかりにくい
    assert { GC.enable == true }
  end

  # 最新のGC情報
  test ".latest_gc_info" do
    # 普通に全取得
    assert { GC.latest_gc_info.kind_of?(Hash) }

    # 戻値を受け取りたいハッシュを指定する場合
    hash = {}
    GC.latest_gc_info(hash)
    assert { hash.kind_of?(Hash) }

    # 特定のキーだけ欲しい場合
    GC.latest_gc_info(:major_by)
  end

  # GC 開始 (実行という意味に近いので終了メソッドはない)
  test ".start" do
    # この3つは同じことらしい
    assert { GC.start == nil } # full_mark: true, immediate_sweep: true
    assert { garbage_collect == nil }
    assert { ObjectSpace.garbage_collect == nil }
  end

  # 統計情報
  test ".stat" do
    assert { GC.stat }
    assert { GC.stat(:count) }
  end

  # すべの機会にGCできるようにしたりする (デバッグ用)
  test ".stress" do
    GC.stress = true
    assert { GC.stress == true }
    GC.stress = false
  end

  # GC用内部定数の値を保持するハッシュテーブル (デバッグ用)
  test GC::INTERNAL_CONSTANTS do
    assert { GC::INTERNAL_CONSTANTS.keys == [:RVALUE_SIZE, :HEAP_PAGE_OBJ_LIMIT, :HEAP_PAGE_BITMAP_SIZE, :HEAP_PAGE_BITMAP_PLANES] }
  end

  # コンパイル時に指定したGCオプション
  test GC::OPTS do
    assert { GC::OPTS == ["USE_RGENGC", "RGENGC_ESTIMATE_OLDMALLOC", "GC_ENABLE_LAZY_SWEEP"] }
  end
end
