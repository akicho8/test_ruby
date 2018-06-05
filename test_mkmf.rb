


require "./test_helper"

require "mkmf"

class TestMkmf < Test::Unit::TestCase
  def main
    # 定数

    if false
      assert_equal("i386-linux", PLATFORM)
      assert_equal("", $CFLAGS)
      assert_equal("", $LDFLAGS)
    end

    # 以下のディレクトリに関連する設定(よくわからない)
    # --with-name-dir=
    # --with-name-include=
    # --with-name-lib=
    dir_config("")

    p have_func("strlen")	#=> checking for strlen()... yes      (true)
    p have_header("stdio.h")	#=> checking for stdio.h... yes       (ture)
    p have_library("c")		#=> checking for main() in -lc... yes (true)

    # Hogeライブラリ用 Makefile の作成
    create_makefile("Hoge")	#=> creating Makefile
  end
end
