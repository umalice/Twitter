//
//  Tweet.m
//  twitter
//
//  Created by Alice Park on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"
#import "APIManager.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        //is this a retweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            //change tweet to original tweet
            dictionary = originalTweet;
        }
        
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.replyCount = [dictionary[@"reply_count"] intValue];
        
        self.entities = dictionary[@"entities"];
        if(self.entities[@"media"]) {
            self.media = (self.entities[@"media"])[0];
            self.tweetPicURLString = self.media[@"media_url_https"];
        }
        
        //initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        //format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        self.createdAtString = [formatter stringFromDate:date];
        self.timeAgoString = date.shortTimeAgoSinceNow;;
        
    }
    
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

- (void)didFavorite:(Tweet *)tweet {
    
    tweet.favorited = YES;
    tweet.favoriteCount += 1;

    [[APIManager shared] favorite:tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited this tweet: %@", tweet.text);
        }
    }];
    
}

- (void)didUnfavorite:(Tweet *)tweet {
    
    tweet.favorited = NO;
    tweet.favoriteCount -= 1;
    
    [[APIManager shared] unfavorite:tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited this tweet: %@", tweet.text);
        }
    }];
    
}

- (void)didRetweet:(Tweet *)tweet {
    
    tweet.retweeted = YES;
    tweet.retweetCount += 1;

    
    [[APIManager shared] retweet:tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted this tweet: %@", tweet.text);
        }
    }];
    
}


- (void)didUnretweet:(Tweet *)tweet {
    
    tweet.retweeted = NO;
    tweet.retweetCount -= 1;

    
    [[APIManager shared] unretweet:tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted this tweet: %@", tweet.text);
        }
    }];
    
}







@end
