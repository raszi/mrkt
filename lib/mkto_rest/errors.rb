class MktoRest::Errors
  RESPONSE_CODE_TO_ERROR = {
    413  => 'RequestEntityTooLarge',
    600  => 'EmptyAccessToken',
    601  => 'AccessTokenInvalid',
    602  => 'AccessTokenExpired',
    603  => 'AccessDenied',
    604  => 'RequestTimedOut',
    605  => 'HTTPMethodNotSupported',
    606  => 'MaxRateLimit',
    607  => 'DailyQuotaReached',
    608  => 'APITemporarilyUnavailable',
    609  => 'InvalidJSON',
    610  => 'RequestedResourceNotFound',
    611  => 'System',
    612  => 'InvalidContentType',
    703  => 'DisabledFeature',
    1001 => 'TypeMismatch',
    1002 => 'MissingParamater',
    1003 => 'UnspecifiedAction',
    1004 => 'LeadNotFound',
    1005 => 'LeadAlreadyExists',
    1006 => 'FieldNotFound',
    1007 => 'MultipleLeadsMatching',
    1008 => 'PartitionAccessDenied',
    1009 => 'PartitionNameUnspecified',
    1010 => 'PartitionUpdateDenied',
    1011 => 'FieldNotSupported',
    1012 => 'InvalidCookieValue',
    1013 => 'ObjectNotFound',
    1014 => 'FailedToCreateObject'
  }

  RESPONSE_CODE_TO_ERROR.values.each do |class_name|
    const_set(class_name, Class.new(Exception))
  end

  Unknown = Class.new(Exception)

  def self.find_by_response_code(response_code)
    const_get(RESPONSE_CODE_TO_ERROR.fetch(response_code, 'Unknown'))
  end
end
