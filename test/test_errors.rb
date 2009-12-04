require 'helper'

class TestErrors < Test::Unit::TestCase
  
  def test_error_for
    assert_equal Spread3::ConnectionClosed, Spread3.error_for(-8)
    assert_equal Spread3::RejectAuth, Spread3.error_for(-9)
    assert_equal Spread3::IllegalSession, Spread3.error_for(-11)
  end
  
  def test_error_for_fallback
    assert_equal Spread3::Error, Spread3.error_for(0)
    assert_equal Spread3::Error, Spread3.error_for(-10)
    assert_equal Spread3::Error, Spread3.error_for(-100)
  end
  
end
