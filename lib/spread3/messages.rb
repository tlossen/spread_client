module Spread3

  class Message
    attr_reader :sender, :text
    
    def initialize(sender, text)
      @sender = sender
      @text = text
    end
  end
  
  class Notification
    attr_reader :group, :members, :cause
    
    def initialize(group, members, cause)
      @group = group
      @members = members
      @cause = cause
    end
  end
  
end
