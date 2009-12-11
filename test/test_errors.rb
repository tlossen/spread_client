require 'helper'

class TestErrors < Test::Unit::TestCase
  
  def test_error_for
    assert_equal SpreadClient::IllegalSpread, SpreadClient.error_for(-1)
    assert_equal SpreadClient::CouldNotConnect, SpreadClient.error_for(-2)
    assert_equal SpreadClient::RejectQuota, SpreadClient.error_for(-3)
    assert_equal SpreadClient::RejectNoName, SpreadClient.error_for(-4)
    assert_equal SpreadClient::RejectIllegalName, SpreadClient.error_for(-5)
    assert_equal SpreadClient::RejectNotUnique, SpreadClient.error_for(-6)
    assert_equal SpreadClient::RejectVersion, SpreadClient.error_for(-7)
    assert_equal SpreadClient::ConnectionClosed, SpreadClient.error_for(-8)
    assert_equal SpreadClient::RejectAuth, SpreadClient.error_for(-9)
    
    assert_equal SpreadClient::IllegalSession, SpreadClient.error_for(-11)
    assert_equal SpreadClient::IllegalService, SpreadClient.error_for(-12)
    assert_equal SpreadClient::IllegalMessage, SpreadClient.error_for(-13)
    assert_equal SpreadClient::IllegalGroup, SpreadClient.error_for(-14)
    assert_equal SpreadClient::BufferTooShort, SpreadClient.error_for(-15)
    assert_equal SpreadClient::GroupsTooShort, SpreadClient.error_for(-16)
    assert_equal SpreadClient::MessageTooLong, SpreadClient.error_for(-17)
  end
  
  def test_error_for_fallback
    assert_equal SpreadClient::Error, SpreadClient.error_for(0)
    assert_equal SpreadClient::Error, SpreadClient.error_for(-10)
    assert_equal SpreadClient::Error, SpreadClient.error_for(-100)
  end
  
end
