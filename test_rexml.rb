require "./test_helper"
require "pathname"
require "rexml/document"
require "kconv"
require "yaml"

class TestREXML < Test::Unit::TestCase
  setup do
  end

  teardown do
  end

  test "case1" do
    source = "<root><a/><b/><c/></root>"
    doc = REXML::Document.new(source)
  end

  test "case2" do
    source = '
<database>
<table name="foo">
<foo/>
</table>
<table name="bar">
<field column1="bar_name1"/>
<field column1="bar_name2"/>
</table>
</database>
'
    doc = REXML::Document.new(source)
    p doc.elements["database/table[@name='bar']/field[@column1='bar_name1']"].attributes
    p doc.elements["database/table[@name='bar']/field[@column1='bar_name1']"].attributes["column1"]
    doc.elements["database/table[@name='bar']"].elements.each{|e|
      p e.attributes["column1"]
    }
  end



end
