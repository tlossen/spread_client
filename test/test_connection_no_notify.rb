require 'helper'

class TestConnectionNoNotify < Test::Unit::TestCase

  def setup
    @c = Spread3::connect('bob', :notify => false)
  rescue 
    raise "this test expects a spread server running at localhost:4803"
  end
  
  def teardown
    @c.disconnect if @c
  end
    
  def test_regular_message
    @c.join('chat')
    @c.multicast('chat', 'hello folks!')
    message = @c.receive
    assert_equal Spread3::Message, message.class
  end
  
end
