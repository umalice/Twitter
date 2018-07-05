//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"
#import "Tweet.h"
#import "User.h"

@interface APIManager : BDBOAuth1SessionManager

@property (nonatomic, strong) User *currentUser;

+ (instancetype)shared;

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)getUserTimeline:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)favoriteTweet:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)retweet:(void(^)(NSArray *tweets, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion;

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion;

- (void)getCurrentUser:(void (^)(User *, NSError *))completion;

@end
