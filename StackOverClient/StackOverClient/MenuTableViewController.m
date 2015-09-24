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

static void *isConnectingContext = &isConnectingContext;

@interface MenuTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) User *authenticatedUser;

@end

@implementation MenuTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
  //Sign Up for KVO Observing
  
  
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
  
    BOOL newValue = [(NSNumber *)change[NSKeyValueChangeNewKey] boolValue];
    if (newValue) {
      [self.activityIndicator startAnimating];
    } else {
      [self.activityIndicator stopAnimating];
      [self viewDidLoad];
    }
    
}

@end
