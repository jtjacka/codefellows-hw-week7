//
//  StackOverFlowParser.h
//  
//
//  Created by Jeffrey Jacka on 9/16/15.
//
//

#import <Foundation/Foundation.h>

@interface StackOverFlowParser : NSObject

+(NSArray  *)questionsFromJSONData:(NSDictionary *)data;

@end
