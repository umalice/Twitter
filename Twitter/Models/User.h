//
//  User.h
//  twitter
//
//  Created by Alice Park on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profilePicURLString;
@property (strong, nonatomic) NSString *headerPicURLString;
@property (nonatomic) int followingCount;
@property (nonatomic) int followerCount;

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

@end
