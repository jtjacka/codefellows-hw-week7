//
//  Question.h
//  
//
//  Created by Jeffrey Jacka on 9/16/15.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Question : NSObject

@property (strong, nonatomic) User *owner;
@property (strong, nonatomic) NSArray *tags;
@property (nonatomic) BOOL isAnswered;
@property (nonatomic) NSInteger viewCount;
@property (nonatomic) NSInteger answerCount;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger questionId;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;

@end
