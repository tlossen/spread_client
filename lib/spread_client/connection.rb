module SpreadClient
  
  class Connection
    
    UNRELIABLE_MESS      = 0x00000001
    RELIABLE_MESS        = 0x00000002
    FIFO_MESS            = 0x00000004
    CAUSAL_MESS          = 0x00000008
    AGREED_MESS          = 0x00000010
    SAFE_MESS            = 0x00000020
    REGULAR_MESS         = 0x0000003f
                         
    SELF_DISCARD		     = 0x00000040
    DROP_RECV            = 0x01000000
                         
    REG_MEMB_MESS        = 0x00001000
    TRANSITION_MESS      = 0x00002000
    CAUSED_BY_JOIN		   = 0x00000100
    CAUSED_BY_LEAVE		   = 0x00000200
    CAUSED_BY_DISCONNECT = 0x00000400
    CAUSED_BY_NETWORK	   = 0x00000800
    MEMBERSHIP_MESS      = 0x00003f00
                         
    ENDIAN_RESERVED      = 0x80000080
    RESERVED             = 0x003fc000
    REJECT_MESS          = 0x00400000

    SERVICE_TYPE = {
      :unreliable => UNRELIABLE_MESS,
      :reliable => RELIABLE_MESS,
      :fifo => FIFO_MESS,
      :causal => CAUSAL_MESS,
      :agreed => AGREED_MESS,
      :safe => SAFE_MESS
    }
    
    DEFAULT_SERVER = 'localhost'
    DEFAULT_PORT = 4803
    DEFAULT_NOTIFY = true
    DEFAULT_PRIORITY = 0
    DEFAULT_SERVICE_TYPE = :safe
    DEFAULT_SELF_DISCARD = false
    DEFAULT_MESSAGE_TYPE = 0
    
    MAX_GROUPS = 16
    MAX_GROUP_LENGTH = 32
    MAX_MESSAGE_LENGTH = 512
    
    def initialize(name, options = {}) #:nodoc:
      @mbox, @name = *connect(name, options)
    end
    
    # the private group name of this connection.
    def name
      @name
    end
    
    # disconnect from the spread server.
    def disconnect
      result = SpreadClient.SP_disconnect(@mbox)
      raise SpreadClient.error_for(result) unless result == 0
    end
  
    # join the given group.
    def join(group)
      result = SpreadClient.SP_join(@mbox, group)
      raise SpreadClient.error_for(result) unless result == 0
    end
  
    # leave the given group.
    def leave(group)
      result = SpreadClient.SP_leave(@mbox, group)
      raise SpreadClient.error_for(result) unless result == 0
    end
  
    # send a message to a group. 
    #
    # options:
    # * :service_type -- can be one of
    #   * :unreliable
    #   * :reliable
    #   * :fifo
    #   * :causal
    #   * :agreed
    #   * :safe (default)
    # * :self_discard -- set this to true if you do not want to receive your own message (default is false) 
    def multicast(group, message, options = {})
      options = { :service_type => DEFAULT_SERVICE_TYPE, :self_discard => DEFAULT_SELF_DISCARD }.merge(options)
      service_type = SERVICE_TYPE[options[:service_type]] | (options[:self_discard] ? SELF_DISCARD : 0)
      result = SpreadClient.SP_multicast(@mbox, service_type, group, DEFAULT_MESSAGE_TYPE, 
        message.length, message)
      raise SpreadClient.error_for(result) if result < 0
    end
  
    # receive the next message or notification.
    #
    # this method blocks until a message is available.
    def receive
      service_type = FFI::MemoryPointer.new(:int)
      sender = FFI::MemoryPointer.new(:char, MAX_GROUP_LENGTH)
      num_groups = FFI::MemoryPointer.new(:int)
      groups = FFI::MemoryPointer.new(:char, MAX_GROUPS * MAX_GROUP_LENGTH)
      message_type = FFI::MemoryPointer.new(:int)
      endian_mismatch = FFI::MemoryPointer.new(:int)
      message = FFI::MemoryPointer.new(:char, MAX_MESSAGE_LENGTH)
      result = SpreadClient.SP_receive(@mbox, service_type, sender, MAX_GROUPS, num_groups, groups, 
        message_type, endian_mismatch, MAX_MESSAGE_LENGTH, message)
      raise SpreadClient.error_for(result) if result < 0
      service_type = service_type.read_int
      sender = sender.read_string
      num_groups = num_groups.read_int
      groups = read_groups(groups, num_groups)
      message = message.read_string
      case
        when regularMessage?(service_type)
          Message.new(sender, message)
        when membershipMessage?(service_type)
          Notification.new(sender, groups, causedBy(service_type))
      end
    end

  private
  
    def regularMessage?(type)         
      (type & REGULAR_MESS > 0) && !(type & REJECT_MESS > 0)
    end
  
    def membershipMessage?(type)
      (type & MEMBERSHIP_MESS > 0) && !(type & REJECT_MESS > 0)
    end
  
    def causedBy(type)
      case
        when type & CAUSED_BY_JOIN > 0 then :join
        when type & CAUSED_BY_LEAVE > 0 && type & REG_MEMB_MESS == 0 then :self_leave
        when type & CAUSED_BY_LEAVE > 0 then :leave
        when type & CAUSED_BY_DISCONNECT > 0 then :disconnect
        when type & CAUSED_BY_NETWORK > 0 then :network
      end
    end

    def connect(name, options = {})
      options = { :server => DEFAULT_SERVER, :port => DEFAULT_PORT, :notify => DEFAULT_NOTIFY }.merge(options)
      spread_server = "#{options[:port]}@#{options[:server]}"
      notify = options[:notify] ? 1 : 0
      mbox = FFI::MemoryPointer.new(:int)
      private_group = FFI::MemoryPointer.new(:char, MAX_GROUP_LENGTH)
      result = SpreadClient.SP_connect(spread_server, name, DEFAULT_PRIORITY, notify, mbox, private_group)
      raise SpreadClient.error_for(result) unless result == 1
      [mbox.read_int, private_group.read_string]
    end
    
    def read_groups(pointer, number)
      groups = []
      number.times do |i|
        groups << pointer[i * MAX_GROUP_LENGTH].read_string
      end
      groups
    end
  
  end

end