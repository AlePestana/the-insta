//
//  HomeViewController.m
//  TheInsta
//
//  Created by marialepestana on 7/8/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "HomeViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "DetailViewController.h"
#import <UIKit/UIKit.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *posts;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Flag that indicates when the app has already made a request to the server
@property (assign, nonatomic) BOOL isMoreDataLoading;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchPosts];
    
    // Refresh control initialization
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl
     addTarget:self
     action:@selector(beginRefresh:)
     forControlEvents:UIControlEventValueChanged
     ];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}


// Function to fetch posts - call Parse get function
- (void)fetchPosts {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    // [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.posts = posts;
            
            // Update table view
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
    
}


// Function that makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self fetchPosts];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.posts[indexPath.row];
        
        DetailViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = post;
        // NSLog(@"Success");
    }
}


// Function of table view data source protocol
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // Deque cell
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    // Update cell with tweet data
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    
    // Return cell to the table view
    return cell;
}


// Function of table view data source protocol
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.posts.count;
}


// Function to load more data - infinite scrolling
- (void)loadMoreData{
    
    [self fetchPosts];
    
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    // [query whereKey:@"likesCount" greaterThan:@100];
    query.limit = self.posts.count;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        // Checks to see if my array did get filled with posts
        if (posts != nil) {
            // do something with the array of object returned by the call
            // Update flag
            self.isMoreDataLoading = false;
            
            // ... Use the new data to update the data source ...
            // ------------------------------------------------------------------>>> NEED TO UPDATE DATA SOURCE
            
            // Update table view
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


// Function to implement infinite scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
        
    }
}


@end
