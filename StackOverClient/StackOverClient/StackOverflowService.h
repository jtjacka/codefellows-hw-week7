//
//  StackOverflowService.h
//  
//
//  Created by Jeffrey Jacka on 9/15/15.
//
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface StackOverflowService : NSObject

+(void)questionsForSearchTerm:(NSString *)search completionHandler:(void(^)(NSArray *questions))completion;
+(void)downloadProfileImages:(NSArray *)questions completionHandler:(void(^)(NSArray *images, UIAlertController *alert))completion;
+(void)profileForCurrentUser:(void(^)(User *authenticatedUser))completion;
+(void)downloadUserProfileImage:(User *)currentUser completionHandler:(void(^)(User *currentUser))completion;
+(void)questionsForCurrentUser:(void(^)(NSArray *questions))completion;

@end
