require 'helper'

class TestSpread3 < Test::Unit::TestCase
  
  def test_regular_message
    assert Spread3.regularMessage?(Spread3::REGULAR_MESS)
    assert Spread3.regularMessage?(Spread3::UNRELIABLE_MESS)
  end
  
  def test_membership_message_is_not_regular_message
    assert !Spread3.regularMessage?(Spread3::MEMBERSHIP_MESS)
    assert !Spread3.regularMessage?(Spread3::TRANSITION_MESS)
  end
  
  def test_reject_message_is_not_regular_message
    assert !Spread3.regularMessage?(Spread3::REJECT_MESS)
    assert !Spread3.regularMessage?(Spread3::REGULAR_MESS & Spread3::REJECT_MESS)
  end
  
  def test_membership_message
    assert Spread3.membershipMessage?(Spread3::MEMBERSHIP_MESS)
    assert Spread3.membershipMessage?(Spread3::TRANSITION_MESS)
  end
  
  def test_regular_message_is_not_membership_message
    assert !Spread3.membershipMessage?(Spread3::REGULAR_MESS)
    assert !Spread3.membershipMessage?(Spread3::UNRELIABLE_MESS)
  end
  
  def test_reject_message_is_not_membership_message
    assert !Spread3.membershipMessage?(Spread3::REJECT_MESS)
    assert !Spread3.membershipMessage?(Spread3::MEMBERSHIP_MESS & Spread3::REJECT_MESS)
  end
  
end
