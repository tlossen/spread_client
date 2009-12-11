module SpreadClient
  extend FFI::Library
  ffi_lib "libspread"

  # open a connection to the given spread server.
  #
  # options:
  # * :server (default is 'localhost')
  # * :port (default is 4803)
  # * :notify -- set this to false if you do not want to receive any group
  #   membership notifications (default is true)
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
