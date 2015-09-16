//
//  StackOverflowService.h
//  
//
//  Created by Jeffrey Jacka on 9/15/15.
//
//

#import <Foundation/Foundation.h>

@interface StackOverflowService : NSObject

+(void)questionsForSearchTerm:(NSString *)search completionHandler:(void(^)(NSArray *questions))completion;

@end
