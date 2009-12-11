module SpreadClient

  class Message
    attr_reader :sender, :text
    
    def initialize(sender, text) #:nodoc:
      @sender = sender
      @text = text
    end
  end
  
  class Notification
    attr_reader :group, :members, :cause
    
    def initialize(group, members, cause) #:nodoc:
      @group = group
      @members = members
      @cause = cause
    end
  end
  
end
