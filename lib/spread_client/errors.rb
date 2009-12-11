module Spread3

  class Error < ::RuntimeError; end

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

  def self.error_for(code)
    errors = [nil, 
      IllegalSpread, CouldNotConnect, RejectQuota, RejectNoName, RejectIllegalName, 
      RejectNotUnique, RejectVersion, ConnectionClosed, RejectAuth, 
      nil,
      IllegalSession, IllegalService, IllegalMessage, IllegalGroup, BufferTooShort,
      GroupsTooShort, MessageTooLong]
    errors.at(code.abs) || Error
  end

end