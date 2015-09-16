//
//  Error.h
//  
//
//  Created by Jeffrey Jacka on 9/15/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const kStackOverFlowErrorDomain;

typedef enum : NSUInteger {
  StackOverFlowBadParameter = 400,
  StackOverFlowAccessTokenRequired = 401,
  StackOverFlowInvalidAccessToken = 402,
  StackOverFlowAccessDenied = 403,
  StackOverFlowNoMethod = 404,
  StackOverFlowKeyRequired = 405,
  StackOverFlowAccessTokenCompromised = 406,
  StackOverFlowWriteFailed = 407,
  StackOVerFlowDuplicateRequest = 409,
  StackOverFlowInternalError = 500,
  StackOverFlowThrottleViolation = 502,
  StackOverFlowTemporarilyUnavaliable = 503,
  StackOverFlowConnectionDown
} StackOverFlowErrorCodes;
