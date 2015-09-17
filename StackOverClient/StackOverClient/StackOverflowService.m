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
#import "Question.h"


@implementation StackOverflowService

+(void)questionsForSearchTerm:(NSString *)search completionHandler:(void(^)(NSArray *questions))completion{
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults valueForKey:@"StackOverFlowToken"];
  NSString *key = @"A6ou8P5JV8PhDqkimDAWdA((";
  
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?order=desc&sort=activity&intitle=%@&site=stackoverflow&key=%@&access_token=%@",search, key, token];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull response) {
    NSLog(@"%ld", operation.response.statusCode);
    
    NSArray *questions = [StackOverFlowParser questionsFromJSONData:response];
    
    completion(questions);
    
  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
    NSLog(@"Search has failed!");
    
  }];
  
}

+(void)profileForCurrentUser:(void(^)(User *authenticatedUser))completion {
  //Retrieve Access Token
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults valueForKey:@"StackOverFlowToken"];
  NSString *key = @"A6ou8P5JV8PhDqkimDAWdA((";
  
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me?order=desc&sort=reputation&site=stackoverflow&key=%@&access_token=%@",key, token];
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull response) {
    
    NSArray *items = response[@"items"];
    NSDictionary *user = items.firstObject;
    User *currentUser = [StackOverFlowParser userFromJSONData:user];
    completion(currentUser);
  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
    completion(nil);
  }];
}

+(NSError *)errorForStatusCode:(NSInteger)statusCode {
  
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 400:
      localizedDescription = @"An invalid parameter was passed";
      errorCode = StackOverFlowBadParameter;
      break;
    case 401:
      localizedDescription = @"This method requires an access token";
      errorCode = StackOverFlowAccessTokenRequired;
      break;
    case 402:
      localizedDescription = @"Access token used is invalid";
      errorCode = StackOverFlowInvalidAccessToken;
      break;
    case 403:
      localizedDescription = @"This access token does not have the permission required";
      errorCode = StackOverFlowAccessDenied;
      break;
    case 404:
      localizedDescription = @"This method does not exist";
      errorCode = StackOverFlowNoMethod;
      break;
    case 405:
      localizedDescription = @"This method requires an application key";
      errorCode = StackOverFlowKeyRequired;
      break;
    case 406:
      localizedDescription = @"Access token has been compromised";
      errorCode = StackOverFlowAccessTokenCompromised;
      break;
    case 407:
      localizedDescription = @"Write operation was rejected";
      errorCode = StackOverFlowWriteFailed;
      break;
    case 409:
      localizedDescription = @"This request has already been run";
      errorCode = StackOVerFlowDuplicateRequest;
      break;
    case 500:
      localizedDescription = @"An unexpected error occured in the API";
      errorCode = StackOverFlowInternalError;
      break;
    case 502:
      localizedDescription = @"Too many attempts, too quickly";
      errorCode = StackOverFlowThrottleViolation;
    case 503:
      localizedDescription = @"Request is temporarily unavaliable";
      errorCode = StackOverFlowTemporarilyUnavaliable;
      break;
    
    default:
      localizedDescription = @"Could not complete operation, please try again later";
      errorCode = StackOverFlowGeneralCode;
      break;
  }
  
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  
  return error;
}

+(NSError *)checkReachability {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    
    return error;
  }
  
  return nil;
}

+(void)downloadUserProfileImage:(User *)currentUser completionHandler:(void(^)(User *currentUser))completion {
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t profileImageQueue = dispatch_queue_create("me.jeffjacka.stackoverflow", DISPATCH_QUEUE_CONCURRENT);
  
  dispatch_group_async(group, profileImageQueue, ^{
    NSString *avatarURL = currentUser.imageURL;
    NSURL *imageURL = [NSURL URLWithString:avatarURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    currentUser.image = image;
    completion(currentUser);
  });
}

+(void)downloadProfileImages:(NSArray *)questions completionHandler:(void(^)(NSArray *images, UIAlertController *alert))completion {
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t imageQueue = dispatch_queue_create("me.jeffjacka.stackoverflow", DISPATCH_QUEUE_CONCURRENT);
  
  NSMutableArray *profileImages = [[NSMutableArray alloc] init];
  
  for (Question *question in questions) {
    dispatch_group_async(group, imageQueue, ^{
      NSString *avatarURL = question.owner.imageURL;
      NSURL *imageURL = [NSURL URLWithString:avatarURL];
      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
      UIImage *image = [UIImage imageWithData:imageData];
      question.owner.image = image;
      
      [profileImages addObject:image];
    });
  }
  
  
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [alertController dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alertController addAction:action];
    completion(profileImages, alertController);
  });
}

@end
