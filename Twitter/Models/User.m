//
//  User.m
//  twitter
//
//  Created by Alice Park on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicURLString = dictionary[@"profile_image_url_https"];
        self.headerPicURLString = dictionary[@"profile_banner_url"];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
    }
    
    return self;
}

@end
