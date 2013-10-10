//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "TweetViewController.h"

@interface TimelineViewController ()

@property (nonatomic, strong) NSMutableArray *tweets; // of Tweets
@property (nonatomic, strong) TweetViewController *tweetViewController;

- (void)onSignOutButton;
- (void)onComposeButton;
- (void)reload;

@end

@implementation TimelineViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @""; // since we don't want navigation text
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    UIImage *image = [UIImage imageNamed:@"twitter.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.navigationItem.titleView = imageView;
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTranslucent:NO];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setBarTintColor:[UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0]];

    NSDictionary *attributes = @{ UITextAttributeTextColor : [UIColor whiteColor],
                                       UITextAttributeFont : [UIFont boldSystemFontOfSize:20] };
    [bar setTitleTextAttributes:attributes];

    [self reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TweetCell";
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
    TweetCell *cell = [nib objectAtIndex:0];

    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70; // TODO: this needs to be dynamic
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Tweet *tweet = self.tweets[indexPath.row];
    self.tweetViewController.tweet = tweet;
    [self.navigationController pushViewController:self.tweetViewController animated:YES];
}

#pragma mark - Private methods

- (TweetViewController *)tweetViewController
{
    if (!_tweetViewController) {
        _tweetViewController = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];
    }
    return _tweetViewController;
}

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onComposeButton {
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

@end
