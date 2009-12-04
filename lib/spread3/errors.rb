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

  def self.error_for(code)
    ERRORS.at(code.abs) || Error
  end

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

end