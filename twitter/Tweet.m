//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)id
{
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

- (NSString *)text
{
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSDate *)createdAt
{
    static NSDateFormatter *formatter = nil; //cached
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EE MM dd HH:mm:ss ZZZ yyyy"];
    }
    return [formatter dateFromString:[self.data valueOrNilForKeyPath:@"created_at"]];
}

- (NSInteger)retweetCount
{
    return [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

- (NSInteger)favoriteCount
{
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] integerValue];
}

- (NSArray *)userMentions
{
    return [self.data valueOrNilForKeyPath:@"user_mentions"];
}

- (User*)user
{
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [[User alloc] initWithDictionary:user];
}

- (void)setRetweeted:(BOOL)retweeted
{
    _retweeted = @(retweeted);
}

- (BOOL)retweeted
{
    if (_retweeted != nil) {
        return [_retweeted boolValue];
    } else {
        return [[self.data valueOrNilForKeyPath:@"retweeted"] integerValue];
    }
}

- (void)setFavorited:(BOOL)favorited
{
    _favorited = @(favorited);
}

- (BOOL)favorited
{
    if (_favorited != nil) {
        return [_favorited boolValue];
    } else {
        return [[self.data valueOrNilForKeyPath:@"favorited"] integerValue];
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array
{
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
