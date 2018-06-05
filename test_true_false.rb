require "./test_helper"

class TestTrueFalse < Test::Unit::TestCase
  test "true, false" do
    assert { true.class == TrueClass }
    assert { false.class == FalseClass }

    assert { true.object_id == 20 }
    assert { false.object_id == 0 }

    assert { true.clone == true } # 昔は TypeError になっていた
    assert { true.dup == true }

    assert { false & true == false }
    assert { false ^ false == false }
    assert { false ^ true == true }
    assert { false | true == true }
    assert { false | false == false }

    # 警告がでる
    # assert { TRUE == true }
    # assert { FALSE == false }
  end
end
