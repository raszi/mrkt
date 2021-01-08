class Mrkt::Errors
  class Error < StandardError
  end

  def self.create_class
    Class.new(Error)
  end

  Unknown = create_class
  EmptyResponse = create_class
  AuthorizationError = create_class

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
    702  => 'RecordNotFound',
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
    1014 => 'FailedToCreateObject',
    1015 => 'LeadNotInList',
    1016 => 'TooManyImports',
    1017 => 'ObjectAlreadyExists',
    1018 => 'CRMEnabled',
    1019 => 'ImportInProgress',
    1020 => 'TooManyCloneToProgram',
    1021 => 'CompanyUpdateNotAllowed',
    1022 => 'ObjectInUse',
    1025 => 'ProgramStatusNotFound',
    1026 => 'CustomObjectNotEnabled',
    1027 => 'MaxActivityTypeLimitReached',
    1028 => 'MaxFieldLimitReached',
    1029 => 'BulkExportQuotaExceeded',
    1035 => 'UnsupportedFilterType',
    1036 => 'DuplicateObjectFoundInInput',
    1042 => 'InvalidRunAtDate',
    1048 => 'CustomObjectDiscardDraftFailed',
    1049 => 'FailedToCreateActivity',
    1077 => 'MergeLeadsCallFailedDueToFieldLength'
  }.freeze

  RESPONSE_CODE_TO_ERROR.each_value do |class_name|
    const_set(class_name, create_class)
  end

  def self.find_by_response_code(response_code)
    const_get(RESPONSE_CODE_TO_ERROR.fetch(response_code, 'Error'))
  end
end
