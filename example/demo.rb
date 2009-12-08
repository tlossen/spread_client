require File.join(File.dirname(__FILE__), '..', 'lib', 'spread3')

c = Spread3::connect('bob', :notify => false)
c.join('chat')
# puts c.receive().inspect
c.multicast('chat', 'hello folks!')
puts c.receive().inspect
c.leave('chat')
# puts c.receive().inspect
c.disconnect
