//
//  ProfileViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/17/15.
//
//

#import "ProfileViewController.h"
#import "StackOverflowService.h"
#import "User.h"

@interface ProfileViewController ()

@property (assign, nonatomic) IBOutlet UIImageView *profileImage;
@property (assign, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) IBOutlet UILabel *locationLabel;
@property (assign, nonatomic) IBOutlet UILabel *ageLabel;
@property (assign, nonatomic) IBOutlet UILabel *reputationLabel;
@property (assign, nonatomic) IBOutlet UILabel *websiteLabel;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
  
  [StackOverflowService profileForCurrentUser:^(User *authenticatedUser) {
    self.nameLabel.text = authenticatedUser.name;
    self.locationLabel.text = authenticatedUser.location;
    self.ageLabel.text = [authenticatedUser.age stringValue];
    self.reputationLabel.text = [authenticatedUser.reputation stringValue];
    self.websiteLabel.text = authenticatedUser.website;
    [self.tableView reloadData];
    [StackOverflowService downloadUserProfileImage:authenticatedUser completionHandler:^(User *currentUser) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        self.profileImage.image = currentUser.image;
        [self.tableView reloadData];
      });
    }];
  }];
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
  [super dealloc];
  
  //Deallocate some shit
  
}

@end
