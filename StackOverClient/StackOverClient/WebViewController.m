//
//  WebViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import "WebViewController.h"
@import WebKit;

@interface WebViewController () <WKNavigationDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  
  NSString *baseURL = @"https://stackexchange.com/oauth/dialog";
  NSString *clientID = @"5567";
  NSString *redirectURI = @"https://stackexchange.com/oauth/login_success";
  NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&no_expiry", baseURL, clientID, redirectURI];
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
  if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
    NSString *fragmentString = navigationAction.request.URL.fragment;
    NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
    NSString *fullTokenParameter = components.firstObject;
    NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
    NSLog(@"%@",token);
    
    //Save Token to NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"StackOverFlowToken"];
    
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:TRUE completion:^{
      //do nothing?
    }];
    
  }
  decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
