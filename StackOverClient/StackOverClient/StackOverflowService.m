//
//  StackOverflowService.m
//  
//
//  Created by Jeffrey Jacka on 9/15/15.
//
//

#import "StackOverflowService.h"
#import "StackOverFlowParser.h"
#import "Error.h"
#import <AFNetworking/AFNetworking.h>

@implementation StackOverflowService

+(void)questionsForSearchTerm:(NSString *)search completionHandler:(void(^)(NSArray *questions))completion{
  
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow",search];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull response) {
    NSLog(@"%ld", operation.response.statusCode);
    
    NSArray *questions = [StackOverFlowParser questionsFromJSONData:response];
    
    completion(questions);
    
  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
    NSLog(@"Search has failed!");
    
  }];
  
}

+(NSError *)errorForStatusCode:(NSInteger)statusCode {
  
  
  
  
  return [[NSError alloc] init];
}

+(NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    
    return error;
  }
  
  return nil;
}

@end
