//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : RestObject {
    NSNumber *_retweeted; // overrides data setting
    NSNumber *_favorited; // overrides data setting
}

- (NSString *)id;
- (NSString *)text;
- (NSDate *)createdAt;
- (NSInteger)favoriteCount;
- (NSInteger)retweetCount;

- (User *)user;

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
