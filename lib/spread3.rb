require 'rubygems'
require 'ffi'

module Spread3
  extend FFI::Library
  ffi_lib "/opt/local/lib/libspread.dylib"

  #define         UNRELIABLE_MESS         0x00000001
  #define         RELIABLE_MESS           0x00000002
  #define         FIFO_MESS               0x00000004
  #define         CAUSAL_MESS             0x00000008
  #define         AGREED_MESS             0x00000010
  #define         SAFE_MESS               0x00000020
  #define         REGULAR_MESS            0x0000003f
  enum :service_type, [
    :unreliable, 0x1,
    :reliable, 0x2,
    :fifo, 0x4,
    :causal, 0x8,
    :agreed, 0x10,
    :safe, 0x20,
    :regular, 0x3f
  ]
  
  # int SP_connect(const char* spread name, const char* private name, int priority, int group membership, mailbox* mbox, char* private group );
  attach_function :SP_connect, [:string, :string, :int, :int, :pointer, :string], :int

  #int SP_disconnect(mailbox mbox);
  attach_function :SP_disconnect, [:int], :int

  #int SP_join(mailbox mbox, const char* group);
  attach_function :SP_join, [:int, :string], :int

  #int SP_leave(mailbox mbox, const char* group);
  attach_function :SP_leave, [:int, :string], :int
  
  #int SP_multicast(mailbox mbox,	service service_type,	const char* group, int16 mess type, int mess len, const char* mess);
  attach_function :SP_multicast, [:int, :service_type, :string, :int16, :int, :string], :int

  
  class Connection
    
    def initialize(name)
      @mbox = FFI::MemoryPointer.new(:pointer)
      Spread3.SP_connect("4803", name, 0, 1, @mbox, "")
    end
    
    def join(group)
      Spread3.SP_join(@mbox.read_int, group)
    end
    
    def leave(group)
      Spread3.SP_leave(@mbox.read_int, group)
    end
    
    def multicast(group, message)
      Spread3.SP_multicast(@mbox.read_int, :safe, group, 0, message.length, message)
    end
    
  end

  def self.connect(name)
    Connection.new(name)
  end
  
end

