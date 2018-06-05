require "./test_helper"
require "ostruct"

class TestOStruct < Test::Unit::TestCase
  test "new" do
    record = OpenStruct.new
    record.subject = "s"
    record.body = "b"

    record2 = OpenStruct.new(:subject => "s", :body => "b")

    assert_equal(record2, record)
  end

  test "delete_field" do
    record = OpenStruct.new(:subject => "s")
    assert_equal("s", record.subject)
    record.delete_field(:subject)
    assert_equal(nil, record.subject)
  end
end
