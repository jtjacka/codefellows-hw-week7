//
//  QuestionSearchViewController.m
//  
//
//  Created by Jeffrey Jacka on 9/14/15.
//
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "StackOverFlowParser.h"
#import "Question.h"

@interface QuestionSearchViewController () <UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *questions;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *search = searchBar.text;
  
  [StackOverflowService questionsForSearchTerm:search completionHandler:^(NSArray *questions) {
    self.questions = questions;
    [self.tableView reloadData];
  }];
  
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];

  Question *currentQuestion = self.questions[indexPath.row];
  
  cell.textLabel.text = currentQuestion.title;
  
  return cell;
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
