require 'rubygems'
require 'ffi'

require File.join(File.dirname(__FILE__), 'spread3', 'connection')
require File.join(File.dirname(__FILE__), 'spread3', 'errors')

module Spread3
  extend FFI::Library
  ffi_lib "libspread"

  Message = Struct.new(:sender, :text)
  Notification = Struct.new(:group, :members, :cause)

  def self.connect(name, options = {})
    Connection.new(name, options)
  end

private

  UNRELIABLE_MESS         = 0x00000001
  RELIABLE_MESS           = 0x00000002
  FIFO_MESS               = 0x00000004
  CAUSAL_MESS             = 0x00000008
  AGREED_MESS             = 0x00000010
  SAFE_MESS               = 0x00000020
  REGULAR_MESS            = 0x0000003f

  SELF_DISCARD		        = 0x00000040
  DROP_RECV               = 0x01000000

  REG_MEMB_MESS           = 0x00001000
  TRANSITION_MESS         = 0x00002000
  CAUSED_BY_JOIN		      = 0x00000100
  CAUSED_BY_LEAVE		      = 0x00000200
  CAUSED_BY_DISCONNECT	  = 0x00000400
  CAUSED_BY_NETWORK	      = 0x00000800
  MEMBERSHIP_MESS         = 0x00003f00

  ENDIAN_RESERVED         = 0x80000080
  RESERVED                = 0x003fc000
  REJECT_MESS             = 0x00400000
  
  enum :service_type, [
    :unreliable, UNRELIABLE_MESS,
    :reliable, RELIABLE_MESS,
    :fifo, FIFO_MESS,
    :causal, CAUSAL_MESS,
    :agreed, AGREED_MESS,
    :safe, SAFE_MESS
  ]
  
  def self.regularMessage?(type)         
    (type & REGULAR_MESS > 0) && !(type & REJECT_MESS > 0)
  end
  
  def self.membershipMessage?(type)
    (type & MEMBERSHIP_MESS > 0) && !(type & REJECT_MESS > 0)
  end
  
  def self.transitionCausedBy(type)
    case
      when type & CAUSED_BY_JOIN > 0 then :join
      when type & CAUSED_BY_LEAVE > 0 && type & REG_MEMB_MESS == 0 then :self_leave
      when type & CAUSED_BY_LEAVE > 0 then :leave
      when type & CAUSED_BY_DISCONNECT > 0 then :disconnect
      when type & CAUSED_BY_NETWORK > 0 then :network
    end
  end

  # int SP_connect(const char* spread name, const char* private name, int priority, int group_membership, 
  #   mailbox* mbox, char* private group);
  attach_function :SP_connect, [:string, :string, :int, :int, :pointer, :pointer], :int

  # int SP_disconnect(mailbox mbox);
  attach_function :SP_disconnect, [:int], :int

  # int SP_join(mailbox mbox, const char* group);
  attach_function :SP_join, [:int, :string], :int

  # int SP_leave(mailbox mbox, const char* group);
  attach_function :SP_leave, [:int, :string], :int
  
  # int SP_multicast(mailbox mbox,	service service_type,	const char* group, int16 mess_type, 
  #  int mess_len, const char* mess);
  attach_function :SP_multicast, [:int, :service_type, :string, :int16, :int, :string], :int

  # int SP_receive(mailbox mbox,	service* service_type, char sender[MAX_GROUP_NAME],	int max_groups, 
  #   int* num groups,	char groups[][MAX_GROUP_NAME], int16* mess_type, int* endian_mismatch,	
  #   int max_mess_len, char* mess);
  attach_function :SP_receive, [:int, :pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, 
    :int, :pointer], :int
    
end

