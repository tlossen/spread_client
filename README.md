# spread3

portable ruby bindings for the spread3 client api.

## Usage

1. install the spread toolkit, see http://www.spread.org
   for instructions

2. install the gem

	$sudo gem install spread3 -s http://gemcutter.org

3. create a simple `spread.conf`

	# one spread daemon running on port 4803 on localhost
	Spread_Segment	127.0.0.255:4803 {
		localhost	127.0.0.1
	}
	
4. start the spread daemon

	$spread -n localhost -c spread.conf
	
5. in a second terminal, start the spread client, connect as user "alice" 
   and join the group "chat"

	$spread -u alice
	
	Spread library version is 3.17.3
	User: connected to 4803@localhost with private group #alice#localhost
	
	User> j chat

	User> 
	============================
	Received REGULAR membership for group chat with 1 members, where I am member 0:
		#alice#localhost
	grp id is 2130706433 1259854449 1
	Due to the JOIN of #alice#localhost
		
6. in a third terminal, run

	$ruby example/demo.rb
	
7. you should see the following output in the second terminal

	User> 
	============================
	Received REGULAR membership for group chat with 2 members, where I am member 0:
		#alice#localhost
		#bob#localhost
	grp id is 2130706433 1259854449 2
	Due to the JOIN of #bob#localhost

	User> 
	============================
	received SAFE message from #bob#localhost, of type 0, (endian 0) to 1 groups 
	(12 bytes): hello folks!

	User> 
	============================
	Received REGULAR membership for group chat with 1 members, where I am member 0:
		#alice#localhost
	grp id is 2130706433 1259854449 3
	Due to the LEAVE of #bob#localhost
	

## Copyright

Copyright (c) 2009 Tim Lossen. See LICENSE for details.
