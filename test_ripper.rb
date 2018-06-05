require "./test_helper"

require "ripper"

# https://docs.ruby-lang.org/ja/latest/class/Ripper.html
class TestRipper < Test::Unit::TestCase
  test "sexp" do
    assert { Ripper.sexp("1 + 2") == [:program, [[:binary, [:@int, "1", [1, 0]], :+, [:@int, "2", [1, 4]]]]] }
  end

  test "lex" do
    assert { Ripper.lex("1 + 2").to_s == "[[[1, 0], :on_int, \"1\", #<Ripper::Lexer::State: EXPR_END|EXPR_ENDARG>], [[1, 1], :on_sp, \" \", #<Ripper::Lexer::State: EXPR_END|EXPR_ENDARG>], [[1, 2], :on_op, \"+\", #<Ripper::Lexer::State: EXPR_BEG>], [[1, 3], :on_sp, \" \", #<Ripper::Lexer::State: EXPR_BEG>], [[1, 4], :on_int, \"2\", #<Ripper::Lexer::State: EXPR_END|EXPR_ENDARG>]]" }
  end

  test "tokenize" do
    assert { Ripper.tokenize("1 + 2") == ["1", " ", "+", " ", "2"] }
  end
end
