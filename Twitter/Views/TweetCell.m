//
//  TweetCell.m
//  twitter
//
//  Created by Alice Park on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {

    _tweet = tweet;
    [self refreshData];
}

- (void)refreshData {
    
    self.tweetText.text = self.tweet.text;
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.timeStamp.text = self.tweet.timeAgoString;
    self.faveCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.replyCount.text = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    
    if(self.tweet.favorited == YES) {
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    } else {
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    NSURL *url = [NSURL URLWithString:self.tweet.user.profilePicURLString];
    self.profilePic.image = nil;
    if (url != nil) {
        [self.profilePic setImageWithURL:url];
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

- (IBAction)didTapRetweet:(id)sender {
    
    if(self.tweet.retweeted == NO) {
        
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
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
            }
            else{
                NSLog(@"Successfully unretweeted this tweet: %@", tweet.text);
            }
        }];
        
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
}




@end
