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
#import "ComposeViewController.h"

#define REUSE_IDENTIFIER @"TweetCell"

@interface TimelineViewController ()

@property (strong, nonatomic) NSMutableArray *tweets; // of Tweets
@property (strong, nonatomic) TweetViewController *tweetViewController;
@property (strong, nonatomic) ComposeViewController *composeViewController;

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

    UINib *nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:REUSE_IDENTIFIER];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(onComposeButton)];

    UIImage *image = [UIImage imageNamed:@"twitter"];
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

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
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
    Tweet *tweet = self.tweets[indexPath.row];
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.tweet = tweet;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:tweet.text];
    NSRange range = NSMakeRange(0, [string length]);
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];

    CGRect frame = [string boundingRectWithSize:CGSizeMake(241, 1000)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        context:nil];
    return MAX(68.0, frame.size.height + 35);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Tweet *tweet = self.tweets[indexPath.row];
    self.tweetViewController.tweet = tweet;
    [self.navigationController pushViewController:self.tweetViewController animated:YES];
}

#pragma mark - Private methods

- (TweetViewController *)tweetViewController
{
    if (!_tweetViewController) {
        _tweetViewController = [[TweetViewController alloc] init];
    }
    return _tweetViewController;
}

- (ComposeViewController *)composeViewController
{
    if (!_composeViewController) {
        _composeViewController = [[ComposeViewController alloc] init];
    }
    return _composeViewController;
}

- (void)onSignOutButton
{
    [User setCurrentUser:nil];
}

- (void)onComposeButton
{
    // TODO: figure out a way to reuse the ComposeViewController
    self.composeViewController.tweet = nil;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:self.composeViewController animated:YES];
}

- (void)reload
{
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        // Do nothing
    }];
}

@end
