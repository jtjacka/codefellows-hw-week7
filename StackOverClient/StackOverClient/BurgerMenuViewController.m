//
//  BurgerMenuViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "WebViewController.h"
#import "ProfileViewController.h"

//Constants
CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
NSTimeInterval const ktimeToSlideMenuOpen = 0.3;
CGFloat const kburgerButtonWidth = 40.0;
CGFloat const kburgerButtonHeight = 40.0;


@interface BurgerMenuViewController () <UITableViewDelegate>

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UITableViewController *mainMenuVC;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
  [self setNeedsStatusBarAppearanceUpdate];
  
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
  mainMenuVC.tableView.delegate = self;
  self.mainMenuVC = mainMenuVC;
  
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearchVC"];
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestionsVC"];
  ProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
  
  self.viewControllers = @[questionSearchVC,myQuestionsVC,profileVC];
  
  [self addChildViewController:questionSearchVC];
  questionSearchVC.view.frame = self.view.frame;
  [self.view addSubview:questionSearchVC.view];
  self.topViewController = questionSearchVC;
  
  UIButton *burgerButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, kburgerButtonWidth,kburgerButtonHeight)];
  [burgerButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];
  self.panGesture = pan;
}

-(void)viewDidAppear:(BOOL)animated {
  //Retrieve Token
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [defaults objectForKey:@"StackOverFlowToken"];
  
  if(!token) {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.mainMenuVC = self.mainMenuVC;
    [self presentViewController:webVC animated:true completion:nil];
    [webVC addObserver:self.mainMenuVC forKeyPath:@"isConnecting" options:NSKeyValueObservingOptionNew context:nil];
  }
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - Actions
-(void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
  }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0 && indexPath.section == 0) {
    return 64;
  }
  return 44;
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender {
  
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  
  if(sender.state == UIGestureRecognizerStateChanged) {
    //User is opening the menu
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width / kburgerOpenScreenDivider) {
      //User has finished opening the menu
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerOpenScreenMultiplier, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
        
      }];
      
    } else {
      //Did open all the way - return to normal state
      [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
      }];
    }
  }
  
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

-(void)switchToViewController:(UIViewController *)newVC {
  [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
    
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    
  } completion:^(BOOL finished) {
    
    //Move Old View Off Screen
    CGRect oldFrame = self.topViewController.view.frame;
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController  removeFromParentViewController];
    
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    [UIView animateWithDuration:ktimeToSlideMenuOpen animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.panGesture];
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}


#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if(![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
  
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
