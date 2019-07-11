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

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;

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
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
