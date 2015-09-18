//
//  MyQuestionsViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import "MyQuestionsViewController.h"
#import "StackOverflowService.h"

@interface MyQuestionsViewController ()

@property (strong, nonatomic) NSArray *myQuestions;

@end

@implementation MyQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [StackOverflowService questionsForCurrentUser:^(NSArray *questions) {
      self.myQuestions = questions;
    }];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
