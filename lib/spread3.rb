require 'rubygems'
require 'ffi'

module Spread3
  extend FFI::Library
  ffi_lib "/opt/local/lib/libspread.dylib"

  #define  UNRELIABLE_MESS  0x00000001
  #define  RELIABLE_MESS    0x00000002
  #define  FIFO_MESS        0x00000004
  #define  CAUSAL_MESS      0x00000008
  #define  AGREED_MESS      0x00000010
  #define  SAFE_MESS        0x00000020
  #define  REGULAR_MESS     0x0000003f
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
      result = Spread3.SP_connect("4803", name, 0, 1, @mbox, "")
      raise Spread3.error_for(result) unless result == 1
    end
    
    def join(group)
      result = Spread3.SP_join(@mbox.read_int, group)
      raise Spread3.error_for(result) unless result == 0
    end
    
    def leave(group)
      Spread3.SP_leave(@mbox.read_int, group)
      raise Spread3.error_for(result) unless result == 0
    end
    
    def multicast(group, message)
      Spread3.SP_multicast(@mbox.read_int, :safe, group, 0, message.length, message)
      raise Spread3.error_for(result) if result < 0
    end
    
  end

  def self.connect(name)
    Connection.new(name)
  end
  
  class Error < ::StandardError; end

  class IllegalSpread < Error; end
  class CouldNotConnect < Error; end
  class RejectQuota < Error; end
  class RejectNoName < Error; end
  class RejectIllegalName < Error; end
  class RejectNotUnique < Error; end
  class RejectVersion < Error; end
  class ConnectionClosed < Error; end
  class RejectAuth < Error; end
  class IllegalSession < Error; end
  class IllegalService < Error; end
  class IllegalMessage < Error; end
  class IllegalGroup < Error; end
  class BufferTooShort < Error; end
  class GroupsTooShort < Error; end
  class MessageTooLong < Error; end
  
private

  ERRORS = [
    nil, 
    #define  ILLEGAL_SPREAD		    -1
    #define  COULD_NOT_CONNECT	  -2
    #define  REJECT_QUOTA         -3
    #define  REJECT_NO_NAME       -4
    #define  REJECT_ILLEGAL_NAME  -5
    #define  REJECT_NOT_UNIQUE    -6
    #define  REJECT_VERSION		    -7
    #define  CONNECTION_CLOSED	  -8
    #define  REJECT_AUTH          -9
    IllegalSpread, CouldNotConnect, RejectQuota, RejectNoName, RejectIllegalName, 
    RejectNotUnique, RejectVersion, ConnectionClosed, RejectAuth, 
    nil,
    #define  ILLEGAL_SESSION		  -11
    #define  ILLEGAL_SERVICE		  -12
    #define  ILLEGAL_MESSAGE		  -13
    #define  ILLEGAL_GROUP		    -14
    #define  BUFFER_TOO_SHORT	    -15
    #define  GROUPS_TOO_SHORT     -16
    #define  MESSAGE_TOO_LONG     -17
    IllegalSession, IllegalService, IllegalMessage, IllegalGroup, BufferTooShort,
    GroupsTooShort, MessageTooLong]
  
  def self.error_for(code)
    ERRORS.at(code.abs) || Error
  end
  
end

