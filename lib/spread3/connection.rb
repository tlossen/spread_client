module Spread3
  
  class Connection
    
    DEFAULT_SERVER = 'localhost'
    DEFAULT_PORT = 4803
    DEFAULT_NOTIFY = true
    DEFAULT_PRIORITY = 0
    DEFAULT_SERVICE_TYPE = :safe
    DEFAULT_MESSAGE_TYPE = 0
    
    MAX_GROUPS = 16
    MAX_GROUP_LENGTH = 32
    MAX_MESSAGE_LENGTH = 512
    
    def initialize(name, options = {})
      @mbox, @name = *connect(name, options)
    end
    
    def name
      @name
    end
    
    def disconnect
      result = Spread3.SP_disconnect(@mbox)
      raise Spread3.error_for(result) unless result == 0
    end
  
    def join(group)
      result = Spread3.SP_join(@mbox, group)
      raise Spread3.error_for(result) unless result == 0
    end
  
    def leave(group)
      result = Spread3.SP_leave(@mbox, group)
      raise Spread3.error_for(result) unless result == 0
    end
  
    def multicast(group, message)
      result = Spread3.SP_multicast(@mbox, DEFAULT_SERVICE_TYPE, group, DEFAULT_MESSAGE_TYPE, 
        message.length, message)
      raise Spread3.error_for(result) if result < 0
    end
  
    def receive()
      service_type = FFI::MemoryPointer.new(:int)
      sender = FFI::MemoryPointer.new(:char, MAX_GROUP_LENGTH)
      num_groups = FFI::MemoryPointer.new(:int)
      groups = FFI::MemoryPointer.new(:char, MAX_GROUPS * MAX_GROUP_LENGTH)
      message_type = FFI::MemoryPointer.new(:int)
      endian_mismatch = FFI::MemoryPointer.new(:int)
      message = FFI::MemoryPointer.new(:char, MAX_MESSAGE_LENGTH)
      result = Spread3.SP_receive(@mbox, service_type, sender, MAX_GROUPS, num_groups, groups, 
        message_type, endian_mismatch, MAX_MESSAGE_LENGTH, message)
      raise Spread3.error_for(result) if result < 0
      service_type = service_type.read_int
      sender = sender.read_string
      num_groups = num_groups.read_int
      groups = read_groups(groups, num_groups)
      message = message.read_string
      case
        when Spread3.regularMessage?(service_type)
          Spread3::Message.new(sender, message)
        when Spread3.membershipMessage?(service_type)
          Spread3::Notification.new(sender, groups, Spread3.transitionCausedBy(service_type))
      end
    end

  private

    def connect(name, options = {})
      options = { :server => DEFAULT_SERVER, :port => DEFAULT_PORT, :notify => DEFAULT_NOTIFY }.merge(options)
      spread_server = "#{options[:port]}@#{options[:server]}"
      notify = options[:notify] ? 1 : 0
      mbox = FFI::MemoryPointer.new(:int)
      private_group = FFI::MemoryPointer.new(:char, MAX_GROUP_LENGTH)
      result = Spread3.SP_connect(spread_server, name, DEFAULT_PRIORITY, notify, mbox, private_group)
      raise Spread3.error_for(result) unless result == 1
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