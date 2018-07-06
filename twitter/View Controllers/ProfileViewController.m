//
//  ProfileViewController.m
//  twitter
//
//  Created by Alice Park on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "User.h"
#import "TweetCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *bioText;
@property (nonatomic, strong) NSMutableArray *tweetArray;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchTweets];
    
        [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
            if(error){
                NSLog(@"Error getting user: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully got user");
                self.currentUser = [[User alloc] initWithDictionary:(NSDictionary *)user];
                [self refreshData];
            }
        }];

}

- (void)fetchTweets {

    [[APIManager shared] getUserTimeline:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded user timeline");
            self.tweetArray = (NSMutableArray *)tweets;
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
        
        [self.tableView reloadData];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    
    self.name.text = self.currentUser.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
    self.followingCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followingCount];
    self.followerCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followerCount];
    self.bioText.text = self.currentUser.bio;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
