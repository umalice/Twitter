//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "OtherProfileViewController.h"


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetCellDelegate>

@property (nonatomic, strong) NSMutableArray *tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets {

    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = (NSMutableArray *)tweets;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    }];

}

-(void)loadMoreData{

    NSNumber *moreCount = [NSNumber numberWithInt:7];
    
    [[APIManager shared] getMoreTweets:moreCount completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetArray = (NSMutableArray *)tweets;
        } else {
            NSLog(@"😫😫😫 Error loading more: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
        
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){

        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;

        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
            self.isMoreDataLoading = false;

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = self.tweetArray[indexPath.row];
    [cell setTweet:cell.tweet];
    cell.delegate = self;
    
    return cell;
}

- (void)didTweet:(Tweet *)tweet {
    
    [self dismissViewControllerAnimated:true completion:nil];
    [self.tweetArray insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    //find command - scrollview offset
    
}

- (IBAction)didTapLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
    
}

- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    
    [self performSegueWithIdentifier:@"otherProfileSegue" sender:user];

}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextViewController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"composeSegue"]) {
        
        ComposeViewController *composeController = (ComposeViewController *)nextViewController.topViewController;
        
        composeController.delegate = self;
        composeController.replyTweet = nil;
        
    } else if([segue.identifier isEqualToString:@"replySegue"]) {
        
        ComposeViewController *replyController = (ComposeViewController *)nextViewController.topViewController;
        replyController.delegate = self;
        replyController.replyTweet = ((TweetCell *)[[sender superview] superview]).tweet;
        
    } else if([segue.identifier isEqualToString:@"detailSegue"]){
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        
        Tweet *tweet = self.tweetArray[indexPath.row];
        
        DetailsViewController *detailController = (DetailsViewController *)nextViewController;
        
        detailController.tweet = tweet;
        
    } else if([segue.identifier isEqualToString:@"otherProfileSegue"]){
        
        OtherProfileViewController *profileController = (OtherProfileViewController *)nextViewController;
        
        profileController.currentUser = sender;
        
    }

    
}



@end
