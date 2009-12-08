require 'helper'

class TestErrors < Test::Unit::TestCase
  
  def test_error_for
    assert_equal Spread3::IllegalSpread, Spread3.error_for(-1)
    assert_equal Spread3::CouldNotConnect, Spread3.error_for(-2)
    assert_equal Spread3::RejectQuota, Spread3.error_for(-3)
    assert_equal Spread3::RejectNoName, Spread3.error_for(-4)
    assert_equal Spread3::RejectIllegalName, Spread3.error_for(-5)
    assert_equal Spread3::RejectNotUnique, Spread3.error_for(-6)
    assert_equal Spread3::RejectVersion, Spread3.error_for(-7)
    assert_equal Spread3::ConnectionClosed, Spread3.error_for(-8)
    assert_equal Spread3::RejectAuth, Spread3.error_for(-9)
    
    assert_equal Spread3::IllegalSession, Spread3.error_for(-11)
    assert_equal Spread3::IllegalService, Spread3.error_for(-12)
    assert_equal Spread3::IllegalMessage, Spread3.error_for(-13)
    assert_equal Spread3::IllegalGroup, Spread3.error_for(-14)
    assert_equal Spread3::BufferTooShort, Spread3.error_for(-15)
    assert_equal Spread3::GroupsTooShort, Spread3.error_for(-16)
    assert_equal Spread3::MessageTooLong, Spread3.error_for(-17)
  end
  
  def test_error_for_fallback
    assert_equal Spread3::Error, Spread3.error_for(0)
    assert_equal Spread3::Error, Spread3.error_for(-10)
    assert_equal Spread3::Error, Spread3.error_for(-100)
  end
  
end
