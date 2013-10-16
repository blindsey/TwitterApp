//
//  User.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "JSONKit.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

NSString * const kCurrentUserKey = @"kCurrentUserKey";

@implementation User

- (NSString *)name
{
    return [self.data valueOrNilForKeyPath:@"name"];
}

- (NSString *)screenName
{
    return [self.data valueOrNilForKeyPath:@"screen_name"];
}

- (NSString *)profileImageURL
{
    return [self.data valueOrNilForKeyPath:@"profile_image_url"];
}

- (NSInteger)statusesCount
{
    return [[self.data valueOrNilForKeyPath:@"statuses_count"] integerValue];
}

- (NSInteger)followersCount
{
    return [[self.data valueOrNilForKeyPath:@"followers_count"] integerValue];
}

- (NSInteger)friendsCount
{
    return [[self.data valueOrNilForKeyPath:@"friends_count"] integerValue];
}

static User *_currentUser;

+ (User *)currentUser
{
    if (!_currentUser) {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserKey];
        if (jsonString) {
            _currentUser = [[User alloc] initWithDictionary:[jsonString objectFromJSONString]];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser
{
    if (currentUser) {
        [[NSUserDefaults standardUserDefaults] setObject:[currentUser JSONString] forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
        [TwitterClient instance].accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!_currentUser && currentUser) {
        _currentUser = currentUser; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (_currentUser && !currentUser) {
        _currentUser = currentUser; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

@end
