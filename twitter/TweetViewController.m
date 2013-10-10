//
//  TweetViewController.m
//  twitter
//
//  Created by Ben Lindsey on 10/8/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetViewController.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;

- (void)attributedStringForStatsLabel;

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];
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
}

- (void)viewDidLayoutSubviews
{
    [self.tweetLabel sizeToFit]; // might have to worry about overflow
}

- (IBAction)doReply {
}

- (IBAction)doRetweet {
}

- (IBAction)doFavorite {
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

@end
