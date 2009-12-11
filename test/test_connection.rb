require 'helper'

class TestConnection < Test::Unit::TestCase

  def setup
    @c = SpreadClient::connect('bob')
  rescue 
    raise "this test expects a spread server running at localhost:4803"
  end
  
  def teardown
    @c.disconnect if @c
  end
  
  def test_self_join_message
    @c.join('chat')
    message = @c.receive
    assert_equal SpreadClient::Notification, message.class
    assert_equal :join, message.cause
  end
  
  def test_self_leave_message
    @c.join('chat')
    @c.receive
    @c.leave('chat')
    message = @c.receive
    assert_equal SpreadClient::Notification, message.class
    assert_equal :self_leave, message.cause
  end
  
  def test_multicast
    @c.join('chat')
    @c.receive
    @c.multicast('chat', 'hello folks!')
    message = @c.receive
    assert_equal SpreadClient::Message, message.class
    assert_equal @c.name, message.sender
    assert_equal 'hello folks!', message.text
  end
  
  def test_multicast_with_self_discard
    @c.join('chat')
    @c.receive
    @c.multicast('chat', 'one', :self_discard => true)
    @c.multicast('chat', 'two')
    message = @c.receive
    assert_equal 'two', message.text
  end
  
  
end
