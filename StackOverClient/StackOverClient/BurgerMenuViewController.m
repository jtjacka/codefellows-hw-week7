//
//  BurgerMenuViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "WebViewController.h"

@interface BurgerMenuViewController ()

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
