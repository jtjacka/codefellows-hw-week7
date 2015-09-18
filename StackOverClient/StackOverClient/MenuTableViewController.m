//
//  MenuTableViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/17/15.
//
//

#import "MenuTableViewController.h"
#import "StackOverflowService.h"
#import "User.h"

@interface MenuTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) User *authenticatedUser;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //Remove Extra Lines in Table View
    self.tableView.tableFooterView = [[UIView alloc] init];
  
  [StackOverflowService profileForCurrentUser:^(User *authenticatedUser) {
    self.userNameLabel.text = authenticatedUser.name;
    [StackOverflowService downloadUserProfileImage:authenticatedUser completionHandler:^(User *currentUser) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.profileImage.image = currentUser.image;
        [self.activityIndicator stopAnimating];
      });
    }];
  }];
  
  self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
