require File.join(File.dirname(__FILE__), '..', 'lib', 'spread_client')

c = Spread3::connect('bob')
c.join('chat')
puts c.receive().inspect
c.multicast('chat', 'hello folks!')
puts c.receive().inspect
c.leave('chat')
puts c.receive().inspect
c.disconnect
