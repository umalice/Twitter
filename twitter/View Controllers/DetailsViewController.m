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
#import "ComposeViewController.h"

@interface DetailsViewController () <ComposeViewControllerDelegate>

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
    
    if(self.tweet.favorited == YES) {
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    } else {
        [self.faveButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweeted == YES) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
    NSURL *url = [NSURL URLWithString:self.tweet.user.profilePicURLString];
    self.profilePic.image = nil;
    if (url != nil) {
        [self.profilePic setImageWithURL:url];
    }
    
}


- (IBAction)didTapRetweet:(id)sender {
    
    if(self.tweet.retweeted == NO) {
        
        [self.tweet didRetweet:self.tweet];
        
    } else {
        
        [self.tweet didUnretweet:self.tweet];
        
    }
    
    [self refreshData];
    
}

- (IBAction)didTapFavorite:(id)sender {
    
    if(self.tweet.favorited == NO) {
        
        [self.tweet didFavorite:self.tweet];
        
    } else {
        
        [self.tweet didUnfavorite:self.tweet];
        
    }
    
    [self refreshData];
}

- (void)didTweet:(Tweet *)tweet {
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *nextViewController = [segue destinationViewController];
    
    if([segue.identifier isEqualToString:@"replySegue"]) {
        
        ComposeViewController *replyController = (ComposeViewController *)nextViewController.topViewController;
        replyController.delegate = self;
        replyController.replyTweet = self.tweet;
        
    }
    
}

@end
