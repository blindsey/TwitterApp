//
//  TweetViewController.m
//  twitter
//
//  Created by Ben Lindsey on 10/8/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@property (strong, nonatomic) ComposeViewController *composeViewController;

- (void)attributedStringForStatsLabel;

- (void)onComposeButton;
- (IBAction)onReplyButton;
- (IBAction)onRetweetButton;
- (IBAction)onFavoriteButton;

- (void)onError:(NSError *)error;

@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    [self.retweetButton setImage:[UIImage imageNamed:@"retweeted"] forState:UIControlStateSelected|UIControlStateDisabled];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favorited"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    User *user = self.tweet.user;
    
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.imageView.image = image;
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;

    self.nameLabel.text = user.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    self.tweetLabel.text = self.tweet.text;

    static NSDateFormatter *formatter = nil; //cached
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateStyle:NSDateFormatterShortStyle];
    }
    self.timeLabel.text = [formatter stringFromDate:self.tweet.createdAt];

    [self attributedStringForStatsLabel];

    self.retweetButton.enabled = !self.tweet.retweeted;
    self.retweetButton.selected = self.tweet.retweeted;
    self.favoriteButton.selected = self.tweet.favorited;
}

- (void)viewDidLayoutSubviews
{
    [self.tweetLabel sizeToFit]; // need to handle overflow
}

# pragma mark - Private methods

- (void)attributedStringForStatsLabel
{
    NSString *text = [NSString stringWithFormat:@"%d RETWEETS  %d FAVORITES",
                      self.tweet.retweetCount, self.tweet.favoriteCount];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:text];

    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    UIColor *color = [UIColor blackColor];
    NSRange range = NSMakeRange(0, [text length]);
    [mas addAttributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : font } range:range];

    UIFont *regularFont = [UIFont systemFontOfSize:[font pointSize] - 2];
    color = [UIColor lightGrayColor];
    range = [text rangeOfString:@"RETWEETS"];
    [mas addAttributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : regularFont } range:range];
    range = [text rangeOfString:@"FAVORITES"];
    [mas addAttributes:@{ NSForegroundColorAttributeName : color, NSFontAttributeName : regularFont } range:range];

    self.statsLabel.attributedText = mas;
}

- (ComposeViewController *)composeViewController
{
    if (!_composeViewController) {
        _composeViewController = [[ComposeViewController alloc] init];
    }
    return _composeViewController;
}

- (void)onComposeButton
{
    self.composeViewController.tweet = nil;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.composeViewController animated:YES];
}

- (IBAction)onReplyButton
{
    self.composeViewController.tweet = self.tweet;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.composeViewController animated:YES];
}

- (IBAction)onRetweetButton
{
    self.retweetButton.enabled = NO;
    if (!self.tweet.retweeted) {
        [[TwitterClient instance] retweetWithStatusId:self.tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
            self.tweet.retweeted = YES;
            self.retweetButton.selected = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.retweetButton.enabled = YES;
            [self onError:error];
        }];
    }
}

- (IBAction)onFavoriteButton
{
    self.favoriteButton.enabled = NO;
    NSLog(@"Favorited: %d", self.tweet.favorited);
    if (self.tweet.favorited) {
        [[TwitterClient instance] unfavoriteWithStatusId:self.tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
            self.tweet.favorited = NO;
            self.favoriteButton.enabled = YES;
            self.favoriteButton.selected = NO;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.favoriteButton.enabled = YES;
            [self onError:error];
        }];
    } else {
        [[TwitterClient instance] favoriteWithStatusId:self.tweet.id success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"response: %@", response);
            self.tweet.favorited = YES;
            NSLog(@"Favorited: %d", self.tweet.favorited);
            self.favoriteButton.enabled = YES;
            self.favoriteButton.selected = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.favoriteButton.enabled = YES;
            [self onError:error];
        }];
    }
}

- (void)onError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't access twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
