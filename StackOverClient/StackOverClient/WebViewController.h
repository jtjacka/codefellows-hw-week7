//
//  WebViewController.h
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"

@interface WebViewController : UIViewController

@property (nonatomic) BOOL isConnecting;
@property (weak, nonatomic) MenuTableViewController *mainMenuVC;

@end
