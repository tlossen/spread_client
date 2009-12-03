require '../lib/spread3'

c = Spread3::connect('paule')
c.join('foo')
c.multicast('foo', 'hello folks!')
c.leave('foo')