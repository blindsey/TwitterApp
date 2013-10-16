//
//  ComposeViewController.h
//  twitter
//
//  Created by Ben Lindsey on 10/16/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) Tweet *tweet;

@end
