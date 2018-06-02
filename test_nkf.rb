# -*- coding: utf-8 -*-
# ↑これいる。rcodetools を正常に動かすため。

require "./test_helper"
require "nkf"

# https://docs.ruby-lang.org/ja/2.4.0/class/NKF.html
class TestNKF < Test::Unit::TestCase
  sub_test_case "class_methods" do
    test "VERSION" do
      assert_equal("2.1.4 (2015-12-12)", NKF::VERSION)
    end

    test "guess" do
      assert_equal("#<Encoding:UTF-8>", NKF.guess("あ").inspect) # 昔は定数だったが使いやすくなった★
      assert_equal("#<Encoding:UTF-8>", NKF::UTF8.inspect)       # 定数は Encoding の alias になった

      # なので
      assert_equal "UTF-8", NKF.guess("あ").name # とするよりも
      assert_equal "UTF-8", "あ".encoding.name   # とした方がいい
    end
  end

  test "nkf" do
    assert_equal("ア表AA(　)!", NKF::nkf("-wZ", "ｱ表AＡ（　）！"))  # Zは全角スペースを変換しない
    assert_equal("ア表AA( )!", NKF::nkf("-wZ1", "ｱ表AＡ（　）！"))  # Z1はスペース1つに変換
    assert_equal("ア表AA(  )!", NKF::nkf("-wZ2", "ｱ表AＡ（　）！")) # Z2はスペース2つに変換
  end

  test "改行が \r のテキストを --unix で \n にする" do
    assert_equal(1, "1\r2".lines.size) # 改行が「\r」の場合、配列にできない
    assert_equal("1\n2\n3", NKF::nkf("--unix", "1\r2\r3"))
  end

  test "hiragana" do
    assert_equal("漢あああ", NKF::nkf("--hiragana -w", "漢あアｱ"))
  end

  test "katakana" do
    assert_equal("漢アアア", NKF::nkf("--katakana -w", "漢あアｱ"))
  end
end
# >> Loaded suite -
# >> Started
# >> ......
# >> 
# >> Finished in 0.003895 seconds.
# >> ------
# >> 6 tests, 12 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
# >> 100% passed
# >> ------
# >> 1540.44 tests/s, 3080.87 assertions/s
