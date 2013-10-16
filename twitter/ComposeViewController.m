//
//  ComposeViewController.m
//  twitter
//
//  Created by Ben Lindsey on 10/16/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)onCancelButton;
- (IBAction)onTweetButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad
{
    self.textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    User *user = [User currentUser];
    
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.imageView.image = image;
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    
    if (self.tweet) {
        NSMutableString *string = [[NSMutableString alloc] init];
        [string appendString:[NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName]];
        for (NSDictionary *params in self.tweet.userMentions) {
            [string appendString:[NSString stringWithFormat:@"@%@ ", params[@"screen_name"]]];
        }
        self.textView.text = string;
    }
    [self textViewDidChange:self.textView];
    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger length = [textView.text length];
    self.placeholderLabel.hidden = length > 0;
    self.lengthLabel.text = [NSString stringWithFormat:@"%d", 140 - length];
    self.lengthLabel.textColor = length > 140 ? [UIColor redColor] : [UIColor lightTextColor];
}

# pragma mark - Private methods

- (IBAction)onCancelButton
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onTweetButton
{
    self.tweetButton.enabled = NO;
    [[TwitterClient instance] tweetWithStatus:self.textView.text inReplyToStatusId:self.tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
        self.tweetButton.enabled = YES;
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Tweeted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.tweetButton.enabled = YES;
        [self onError:error];
    }];
}

- (void)onError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't access twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
