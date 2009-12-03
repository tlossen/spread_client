require File.join(File.dirname(__FILE__), '..', 'lib', 'spread3')

c = Spread3::connect('bob')
c.join('chat')
c.multicast('chat', 'hello folks!')
c.leave('chat')