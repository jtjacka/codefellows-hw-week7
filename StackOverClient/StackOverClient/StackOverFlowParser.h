//
//  StackOverFlowParser.h
//  
//
//  Created by Jeffrey Jacka on 9/16/15.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface StackOverFlowParser : NSObject

+(NSArray  *)questionsFromJSONData:(NSDictionary *)data;
+(User *)userFromJSONData:(NSDictionary *)data;

@end
