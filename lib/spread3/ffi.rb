module Spread3
  extend FFI::Library
  ffi_lib "libspread"

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

  def self.connect(name, options = {})
    Connection.new(name, options)
  end

private
  
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
  attach_function :SP_multicast, [:int, :int, :string, :int16, :int, :string], :int

  # int SP_receive(mailbox mbox,	service* service_type, char sender[MAX_GROUP_NAME],	int max_groups, 
  #   int* num groups,	char groups[][MAX_GROUP_NAME], int16* mess_type, int* endian_mismatch,	
  #   int max_mess_len, char* mess);
  attach_function :SP_receive, [:int, :pointer, :pointer, :int, :pointer, :pointer, :pointer, :pointer, 
    :int, :pointer], :int
    
end
