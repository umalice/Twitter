//
//  DetailsViewController.m
//  twitter
//
//  Created by Alice Park on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ReplyViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *faveCount;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *faveButton;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    
    self.tweetText.text = self.tweet.text;
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.timeStamp.text = self.tweet.createdAtString;
    self.faveCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    
    NSURL *url = [NSURL URLWithString:self.tweet.user.profilePicURLString];
    self.profilePic.image = nil;
    if (url != nil) {
        [self.profilePic setImageWithURL:url];
    }
    
}


- (IBAction)didTapRetweet:(id)sender {
    
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    [self refreshData];
    
    if(self.tweet.retweeted == NO) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully retweeted this tweet: %@", tweet.text);
            }
        }];
    
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    
    } else {
    
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
    
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            } else{
                NSLog(@"Successfully unretweeted this tweet: %@", tweet.text);
            }
        }];
    
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    
    if(self.tweet.favorited == NO) {
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited this tweet: %@", tweet.text);
            }
        }];
        
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        
    } else {
        
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited this tweet: %@", tweet.text);
            }
        }];
        
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController *nextViewController = [segue destinationViewController];
    
    if([nextViewController isKindOfClass:[ReplyViewController class]]) {
        
        ((ReplyViewController *)nextViewController).oldTweet = self.tweet;
        
    }
    
    
    
}

@end
