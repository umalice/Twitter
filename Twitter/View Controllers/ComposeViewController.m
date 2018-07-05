//
//  ComposeViewController.m
//  twitter
//
//  Created by Alice Park on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "Tweet.h"
#import "APIManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeView;
@property (weak, nonatomic) IBOutlet UILabel *replyName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.composeView becomeFirstResponder];
    
    if(self.replyTweet) {
        
        self.replyName.text = [NSString stringWithFormat:@"Replying to @%@", self.replyTweet.user.screenName];
        [self.replyName setHidden:NO];
        self.topConstraint.constant = 48;
        
        [[APIManager shared] getCurrentUser:^(User *user, NSError *error) {
            if(error){
                NSLog(@"Error getting user: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully got user");
                User *currentUser = [[User alloc] initWithDictionary:(NSDictionary *)user];
                NSURL *url = [NSURL URLWithString:currentUser.profilePicURLString];
                self.profilePic.image = nil;
                [self.profilePic setImageWithURL:url];
            }
        }];
        

        
    } else {
        [self.replyName setHidden:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetButton:(id)sender {
    
    NSString *newTweet;
    if(self.replyTweet) {
        
        newTweet = [NSString stringWithFormat:@"@%@ %@", self.replyTweet.user.screenName, self.composeView.text];
    } else {
        newTweet = self.composeView.text;
    }

    
    [[APIManager shared] postStatusWithText:newTweet completion:^(Tweet *tweet, NSError *error) {
        
        if (newTweet) {
            NSLog(@"😎😎😎 Composed new tweet!");
            [self.delegate didTweet:tweet];

        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }
    ];
    
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
