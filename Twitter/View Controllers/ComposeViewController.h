//
//  ComposeViewController.h
//  twitter
//
//  Created by Alice Park on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate

- (void)didTweet:(Tweet *)tweet;


@end

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) Tweet *replyTweet;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end


