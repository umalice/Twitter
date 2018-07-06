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

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerPic;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData {
    
    self.name.text = self.currentUser.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
    self.followingCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followingCount];
    self.followerCount.text = [NSString stringWithFormat:@"%d", self.currentUser.followerCount];

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

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
