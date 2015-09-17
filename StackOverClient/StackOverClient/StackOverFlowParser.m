//
//  StackOverFlowParser.m
//  
//
//  Created by Jeffrey Jacka on 9/16/15.
//
//

#import "StackOverFlowParser.h"
#import "Question.h"

@implementation StackOverFlowParser

+(NSArray  *)questionsFromJSONData:(NSDictionary *)data {
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  
  NSArray *items = data[@"items"];
  
  for (NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    
    //TODO - Parse rest of JSON if needed
    User* owner = [self userFromJSONData:item[@"owner"]];
    question.owner = owner;
    
    [questions addObject:question];
    
  }
  
  return questions;
}

+(User *)userFromJSONData:(NSDictionary *)data {
  User *newUser = [[User alloc] init];
  
  newUser.name = data[@"display_name"];
  newUser.imageURL = data[@"profile_image"];
  
  return newUser;
}


@end
