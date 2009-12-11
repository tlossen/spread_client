# spread_client

portable ruby bindings for the [spread toolkit](http://www.spread.org), version 3.17.x --
built with [ffi](http://github.com/ffi/ffi).

## usage

    sudo gem install spread-client -s http://gemcutter.org
    
then

    require 'rubygems'
    require 'spread_client'

    c = SpreadClient::connect('bob')
    c.join('chat')
    c.multicast('chat', 'hello folks!')
    c.leave('chat')
    c.disconnect

## setup instructions

1. install the spread toolkit:

        $ sudo port install spread
        
    or
    
        $ sudo apt-get install spread
        
    or see <http://www.spread.org> for instructions on how to install from source.

2. create a simple `spread.conf`:

        # one spread daemon running on port 4803 on localhost
        Spread_Segment 127.0.0.255:4803 {
        	localhost 127.0.0.1
        }
	
3. start the spread daemon:

        $ spread -n localhost -c spread.conf

## Copyright

Copyright (c) 2009 Tim Lossen. See LICENSE for details.
