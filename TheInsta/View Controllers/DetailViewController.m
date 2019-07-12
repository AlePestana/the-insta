//
//  DetailViewController.m
//  TheInsta
//
//  Created by marialepestana on 7/10/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "DetailViewController.h"
#import "Post.h"
#import "Parse/Parse.h"
#import "NSDate+DateTools.h"
#import "ProfileViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFFileObject *userImageFile = self.post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            
            self.nameLabel.text = self.post.author.username;
            self.caption.text = self.post.caption;
            self.postImageView.image = [UIImage imageWithData:data];
            self.likeCount.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
            self.commentCount.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
            
            
            // Profile image
            PFFileObject *profileImageFile = self.post.author[@"profileImage"];
            
            [profileImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    self.profileImageView.image = [UIImage imageWithData:data];
                }
            }];
            
            // Timestamp
            // Format createdAt date string
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // Configure the input format to parse the date string
            formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
            // Convert String to Date
            NSDate *date = self.post.createdAt;
            // Configure output format
            // Date
            NSDate *timeAgoDate = [NSDate dateWithTimeInterval:0 sinceDate:date];
            
            // Convert Date to String
            self.timestamp.text = timeAgoDate.shortTimeAgoSinceNow;
            
        } else {
            NSLog(@"Image not taken from PFFile");
        }
    }];
    
    // Tap gesture for profile image
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.profileImageView setUserInteractionEnabled:YES];
    [self.profileImageView addGestureRecognizer:singleFingerTap];
    
    
    //The event handling method
    
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self performSegueWithIdentifier:@"usersProfileSegue" sender:self];
    NSLog(@"Success");
    //Do stuff here...
    
}

// Function that refreshes the data
-(void) refreshData {
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
}


- (IBAction)didTapFavorite:(UIButton *)sender {
    
    // Update cell UI
    if (self.post.favorited) {
        self.post.favorited = NO;
        // int number = [[dict objectForKey:@"integer"] intValue];
        int count = [self.likeCount.text intValue];
        self.post.likeCount = [NSNumber numberWithInt:(count-1)];
        // self.post.likeCount -= 1;
        self.likeButton.selected = NO;
        
        [self.likeButton setSelected:NO];
        
        [self refreshData];
        
        // Send a POST request to the POST favorites/create endpoint
        // For favoriting
        [Post updateLikeCount:self.post.likeCount withObjectID:self.post.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"%@",error);
            } else {
                NSLog(@"Like successful");
            }
        }];
        
    } else {
        self.post.favorited = YES;
        
        int count = [self.likeCount.text intValue];
        self.post.likeCount = [NSNumber numberWithInt:(count+1)];
        
        // self.post.likeCount += 1;
        self.likeButton.selected = YES;
        // Refresh image
        // [sender setImage:self.favoriteButton forState:UIControlStateSelected];
        [self.likeButton setSelected:YES];
        
        [self refreshData];
        
        // Send a POST request to the POST favorites/create endpoint
        // For favoriting
        [Post updateLikeCount:self.post.likeCount withObjectID:self.post.objectId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"%@",error);
            } else {
            }
        }];
    }

    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"usersProfileSegue"]) {
        
        PFUser *user = [PFUser currentUser];
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
        
        NSLog(@"Success seeing users profile");
    }
}


@end
