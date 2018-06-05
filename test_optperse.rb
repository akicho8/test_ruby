#!/usr/local/bin/ruby -Ku
# Time-stamp: <2009-05-18 11:26:33 ikeda>
# $Id: test_template.rb 1183 2007-10-23 03:28:27Z ikeda $

require "test/unit"
require "optparse"
require "time"

class TestOptparse < Test::Unit::TestCase
  def test_new
    object = OptionParser.new(banner=nil, width=32, indent = ' '*4)
    assert_equal "Usage: test_optperse [options]", object.banner
    assert_equal 32, object.summary_width
    assert_equal "    ", object.summary_indent
    assert_equal "test_optperse", object.program_name
    assert_equal nil, object.version
    assert_equal nil, object.release

    # ’¥Ð’¡¼’¥¸’¥ç’¥ó’¤È’¥ê’¥ê’¡¼’¥¹’¤ò’»Ø’Äê’¤Ç’¤­’¤ë
    object.version = "1.0.0"
    object.release = "rc"
    assert_equal "test_optperse 1.0.0 (rc)", object.ver
  end

  # opts.on ’¤Î’¥Ö’¥í’¥Ã’¥¯’¤Ç’¼õ’¤±’¼è’¤ë’»þ’ÅÀ’¤Ç’¡¢’ÆÈ’¼«’¤Î’¥¯’¥é’¥¹’¤Î’¥¤’¥ó’¥¹’¥¿’¥ó’¥¹’¤Ë’¤Ç’¤­’¤ë
  def test_accept
    Object.const_set("MyTime", Class.new(Time))
    OptionParser.accept(MyTime) do |value|
      begin
        MyTime.parse(value)
      rescue
        raise OptionParser::InvalidArgument, value
      end
    end
    opts = OptionParser.new
    opts.on("-t", "--time [TIME]", MyTime) do |time|
      p time       #=> Mon May 18 12:15:00 +0900 2009
      p time.class #=> Time
    end
    opts.parse!(["--time", "12:15"])
  end
end
