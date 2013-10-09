//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSDate *)createdAt {
    static NSDateFormatter *formatter = nil; //cached
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EE MM dd HH:mm:ss ZZZ yyyy"];
    }
    return [formatter dateFromString:[self.data valueOrNilForKeyPath:@"created_at"]];
}

- (NSInteger)retweeted {
    return [[self.data valueOrNilForKeyPath:@"retweeted"] integerValue];
}

- (NSInteger)retweetCount {
    return [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

- (NSInteger)favoriteCount {
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] integerValue];
}

- (User*)user {
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [[User alloc] initWithDictionary:user];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
