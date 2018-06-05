


require "./test_helper"

class TestProcess < Test::Unit::TestCase
  test "egid" do		# egid=
  end
  test "euid" do		# euid=
  end
  test "exit!" do
  end
  test "fork" do # 親の環境を子供は引き継ぐが親の環境は一切変更されない証明
    x = 1
    Process.fork{x += 1; assert_equal(2, x); exit(1)} #=> 2
    Process.fork{x += 1; assert_equal(2, x); exit(2)} #=> 2
    Process.wait
    Process.wait
    assert_equal(1, x)
  end
  def __test_s_fork_env_check	# プロセスIDが異る証明
    puts "A self=#{Process.pid} super=#{Process.ppid}"
    Process.fork{puts "1 self=#{Process.pid} super=#{Process.ppid}"}
    Process.fork{puts "2 self=#{Process.pid} super=#{Process.ppid}"}
    Process.wait
    Process.wait
  end
  test "getpgid" do
    assert(Process.getpgid(Process.pid) != 0)
  end
  test "setpgid" do
  end
  test "getpgrp" do
    assert(Process.getpgrp != 0)
  end
  test "setpgrp" do
  end
  test "getpriority" do
    pid = 0			# 0は現在のプロセスを意味する
    assert_kind_of(Integer, Process.getpriority(Process::PRIO_USER, pid))
    assert_kind_of(Integer, Process.getpriority(Process::PRIO_PGRP, pid))
    assert_kind_of(Integer, Process.getpriority(Process::PRIO_PROCESS, pid))
  end
  test "setpriority" do
  end
  test "uid" do		# uid=
    assert_kind_of(Integer, Process.uid)
  end
  test "gid" do		# gid=
    assert_kind_of(Integer, Process.gid)
  end
  test "pid" do
    assert(Process.pid != 0)
  end
  test "ppid" do
    assert(Process.ppid != 0)
  end
  def __test_s_kill
    x = 0
    trap("SIGHUP"){x=1}
    Process.kill("SIGHUP", 0)
    assert_equal(1, x)
  end
  test "wait" do
    return if $0 != __FILE__

    assert_raises(Errno::ECHILD){Process.wait} # 子プロセスが無い状態ならエラーになる

    # プロセスを生成したらプロセスの数だけ待たなくてはいけない
    # 子プロセスの実行順序は曖昧なので sleep を入れている
    x = Process.fork{sleep(0.1); exit(1)}	# exitの戻り値に意味無し
    y = Process.fork{sleep(0.2); exit(2)}
    a = Process.wait		# waitの場合、戻り値は取得出来ない
    b = Process.wait		# 例にここをはずすと次のassertで引っかかる
    assert_equal(x, a)
    assert_equal(y, b)

    assert_raises(Errno::ECHILD){Process.wait} # 子プロセスが無い状態ならエラーになる
  end
  test "wait2" do		# 子プロセスの戻り値が取得出来る wait
    return if $0 != __FILE__

    assert_raises(Errno::ECHILD){Process.wait2} # 子プロセスが無い状態ならエラーになる

    # プロセスを生成したらプロセスの数だけ待たなくてはいけない
    # 子プロセスの実行順序は曖昧なので sleep を入れている
    x = Process.fork{sleep(0.1); exit(1)}
    y = Process.fork{sleep(0.2); exit(2)}
    a = Process.wait2
    b = Process.wait2

    # 戻り値が取得出来ている(exit(1)の場合、左８ビットシフトされるので 256 になる)
    assert_equal([x, 256], a)
    assert_equal([y, 512], b)

    assert_raises(Errno::ECHILD){Process.wait2} # 子プロセスが無い状態ならエラーになる

  end
  test "waitall" do		# 1.7以上
  end

  test "waitpid" do
    # 普通にフラグを指定しないで使った場合
    x = Process.fork {sleep(0.1)}
    assert_equal(x, Process.waitpid(x))	# フラグ指定なし
    assert_raises(Errno::ECHILD){Process.waitpid(x)}	# もう終了しているのでエラー
  end
  test "waitpid_WNOHANG" do	# 子プロセスの終了を待たない？
    # 子プロセスの終了を待たないフラグをつけてみたけど子プロセスは終了せずに
    # nilがかえってきただけだった
    x = Process.fork {sleep(0.1)}
    assert_equal(nil, Process.waitpid(x, Process::WNOHANG))
    assert_equal(x, Process.waitpid(x))	# フラグ指定なし
    assert_raises(Errno::ECHILD){Process.waitpid(x)}	# もう終了しているのでエラー
  end
  test "waitpid_WUNTRACED" do	# ステータスを報告してない停止した子プロセスも持つ
    # このフラグを指定したらフラグ無しの時と同様にプロセスが終了した。意味はわからない
    x = Process.fork {sleep(0.1)}
    assert_equal(x, Process.waitpid(x, Process::WUNTRACED))
    assert_raises(Errno::ECHILD){Process.waitpid(x)}	# もう終了しているのでエラー
  end

  test "waitpid2" do		# waitpid と戻り値の形が違うだけ
    x = Process.fork {sleep(0.1); exit(1)}
    assert_equal([x, 256], Process.waitpid2(x))	# フラグ指定なし
    assert_raises(Errno::ECHILD){Process.waitpid2(x)}	# もう終了しているのでエラー
  end
end
