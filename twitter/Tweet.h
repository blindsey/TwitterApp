//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSDate *createdAt;
@property (nonatomic, assign, readonly) NSInteger retweeted;
@property (nonatomic, assign, readonly) NSInteger favoriteCount;
@property (nonatomic, assign, readonly) NSInteger retweetCount;
@property (nonatomic, strong, readonly) User* user;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
