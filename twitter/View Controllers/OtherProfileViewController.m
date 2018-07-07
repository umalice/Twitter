//
//  OtherProfileViewController.m
//  twitter
//
//  Created by Alice Park on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "OtherProfileViewController.h"
#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "APIManager.h"

@interface OtherProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetArray;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchTweets];
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchTweets {
    
    [[APIManager shared] getOtherUserTimeline:self.currentUser.screenName completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            self.tweetArray = (NSMutableArray *)tweets;
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
        
    }];
    
}

- (void)refreshData {
    
    self.name.text = self.currentUser.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
    self.followingCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followingCount];
    self.followerCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followerCount];
    self.bio.text = self.currentUser.bio;
    
    NSURL *profilePicURL = [NSURL URLWithString:self.currentUser.profilePicURLString];
    self.profilePic.image = nil;
    if (profilePicURL != nil) {
        [self.profilePic setImageWithURL:profilePicURL];
    }
    
    NSURL *headerPicURL = [NSURL URLWithString:self.currentUser.headerPicURLString];
    self.headerPic.image = nil;
    if (headerPicURL != nil) {
        [self.headerPic setImageWithURL:headerPicURL];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    cell.tweet = self.tweetArray[indexPath.row];
    [cell setTweet:cell.tweet];
    
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
