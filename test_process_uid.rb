

require "./test_helper"
require "etc"

class TestProcessUid < Test::Unit::TestCase
  test "whoami" do
    p Process.uid = 0
    # p Etc.getlogin
  end

  # test "rid" do
  #   assert_equal 501, Process::UID.rid
  # end
  # 
  # test "eid" do
  #   assert_equal 501, Process::UID.eid
  # end
  # 
  # test "re_exchangeable" do
  #   assert_equal false, Process::UID.re_exchangeable?
  # end
  # 
  # test "change_privilege" do
  #    p Process::UID.change_privilege(0)
  # end
  # 
  # test "switch" do
  #   # Process::UID.switch do
  #   #   p Process::UID.rid, Process::UID.eid
  #   # end
  # end
end
