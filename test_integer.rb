require "./test_helper"

# https://docs.ruby-lang.org/ja/latest/class/Integer.html
class TestInteger < Test::Unit::TestCase
  test ".sqrt" do
    assert { Integer.sqrt(2) == 1 }
  end

  test "+, -, *, /, %, div, fdiv, modulo, divmod, remainder" do
    assert { 2 + 3 == 5 }
    assert { 2 - 3 == -1 }
    assert { 2 * 3 == 6 }
    assert { 2 / 3 == 0 }

    assert { 10 % 3 == 1 }
    assert { 10.div(3) == 3 }
    assert { 10.fdiv(3) == 3.3333333333333335 }
    assert { 10.modulo(3) == 1 }
    assert { 10.divmod(3) == [3, 1] }

    # ★ 符号を受け継ぐ modulo
    assert { -10.remainder(3) == -1 }
  end

  test "&" do
    assert { 0b1010 & 0b11 == 2 }
  end

  test "**, pow" do
    assert { 2**0 == 1 }
    assert { 2**1 == 2 }
    assert { 2**2 == 4 }

    assert { 2.pow(100) == 1267650600228229401496703205376 }

    # 第二引数を指定すると速くなる
    "#{<<-"{#"}\n#{<<-'};'}"
    {#
      require "active_support/core_ext/benchmark"
      def _; "%7.2f ms" % Benchmark.ms { 100000.times { yield } } end
      assert_raise() { _ { 2.pow(10000).modulo(10000) } }
      assert_raise() { _ { 2.pow(10000, 10000)        } }
    };

    assert { 2.pow(100).modulo(1000) == 376 }
    assert { 2.pow(100, 1000) == 376 }
  end

  test "-@" do
    assert { -1 == -1 }
  end

  test "operator" do
    1 < 2
    1 <= 1
    1 >= 1
    1 > 0
  end

  test "<=>" do
    assert { (1 <=> 2) == -1 }
  end

  test "==, ===" do
    1 == 1
  end

  test "<<, >>" do
    assert { 1 << 1 == 2 }
    assert { 2 >> 1 == 1 }
  end

  test "[]" do
    assert { 0b1010[0] == 0 }
    assert { 0b1010[1] == 1 }
    assert { 0b1010[2] == 0 }
    assert { 0b1010[3] == 1 }
    assert { 0b1010[4] == 0 }
    assert { 0b1010[5] == 0 }
    assert { 0b1010[6] == 0 }
    assert { 0b1010[7] == 0 }
  end

  test "^" do
    assert { 0b1111 ^ 0b1010 == 5 }
  end

  test "abs, magnitude" do
    assert { -10.abs == 10 }
    assert { -10.magnitude == 10 }
  end

  test "allbits?, anybits?, nobits?" do
    assert { 0b1111.allbits?(0b11) == true  }
    assert { 0b1101.anybits?(0b11) == true  }
    assert { 0b1100.nobits?(0b11) == true }
  end

  test "bit_length" do
    assert { 255.bit_length == 8 }
    assert { 256.bit_length == 9 }
  end

  # ★ 整数に対しても使える
  test "ceil, floor, round, truncate" do
    # 上に近い整数
    assert { 15.ceil(-1) == 20 }

    # # 下に近い整数
    assert { -15.floor(-1) == -20 }

    # 上下に近い整数
    assert { 15.round(-1) == 20 }
    assert { -15.round(-1) == -20 }
    assert { 15.round(-1, half: :up) == 20 }
    assert { 15.round(-1, half: :down) == 10 }
    # 偶数
    assert { 15.round(-1, half: :even) == 20 }

    # # 0に近い整数
    assert { +15.truncate(-1) == 10 }
    assert { -15.truncate(-1) == -10 }

    # 1円の単位を省略して価格の桁を見栄えよくする例
    assert { 979.round(-1) == 980 }
    assert { 980.round(-1) == 980 }
    assert { 981.round(-1) == 980 }
  end

  test "chr" do
    assert { 65.chr == "A" }

    # ★ 256以上のコードに対してもエンコーディングを指定すれば変換できる
    assert { 0x3042.chr(Encoding::UTF_8) == "あ" }

    assert { 65.ord == 65 }
  end

  # 自分自身を返す
  test "ord" do
    assert { 65.ord == 65 }

    # なので次のようなことができる
    assert { ["A", 65].map(&:ord) == [65, 65] }
  end

  # 分子と分母
  test "numerator, denominator" do
    assert { 123.numerator == 123 }
    assert { 123.denominator == 1 }
  end

  # N進数での表示を右から取得
  test "digits" do
    assert { 16.digits == [6, 1] }
    assert { 16.digits(2) == [0, 0, 0, 0, 1] }
  end

  test "downto" do
    assert { 3.downto(1).to_a == [3, 2, 1] }
  end

  test "even?, odd?" do
    assert { 0.even? == true }
    assert { 0.odd? == false }
  end

  test "gcd, lcm, gcdlcm" do
    assert { 12.gcd(15) == 3 }
    assert { 3.lcm(4) == 12 }
    assert { 12.gcdlcm(15) == [3, 60] }
  end

  test "to_s, inspect" do
    assert { 5.to_s(2) == "101" }
    assert { 5.inspect(2) == "101" }
  end

  # 常に true
  test "integer?" do
    assert { 1.integer? == true }
  end

  test "next, succ, pred" do
    assert { 0.next == 1 }
    assert { 0.succ == 1 }
    assert { 0.pred == -1 }
  end

  # Rational 化
  test "rationalize" do
    # ポルモリフィックな使い方ができるように引数(許容範囲)は指定できても無視される
    assert { 2.rationalize(123) == (2/1) }
  end

  test "size" do
    assert { 1.size == 8 }
  end

  test "times" do
    assert { 2.times.to_a == [0, 1] }
  end

  test "to_f" do
    assert { 1.to_f == 1.0 }
  end

  test "to_i, to_int" do
    assert { 1.to_i == 1 }
    assert { 1.to_int == 1 }
  end

  test "to_r" do
    assert { 1.to_r == (1/1) }
  end

  test "upto" do
    assert { 1.upto(3).to_a == [1, 2, 3] }
  end

  test "|" do
    assert { 0b10 | 0b01 == 3 }
  end

  test "~" do
    assert { ~0 == -1 }
  end
end
