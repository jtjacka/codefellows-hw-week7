//
//  StackOverflowService.h
//  
//
//  Created by Jeffrey Jacka on 9/15/15.
//
//

#import <UIKit/UIKit.h>

@interface StackOverflowService : NSObject

+(void)questionsForSearchTerm:(NSString *)search completionHandler:(void(^)(NSArray *questions))completion;
+(void)downloadProfileImages:(NSArray *)questions completionHandler:(void(^)(NSArray *images, UIAlertController *alert))completion;

@end
