//
//  PostCell.m
//  TheInsta
//
//  Created by marialepestana on 7/10/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"
#import "NSDate+DateTools.h"

@implementation PostCell

- (void)setPost:(Post *)post {
    _post = post;
    
    self.profileImage.layer.cornerRadius = 27;
    
    PFFileObject *userImageFile = post.image;
    
    PFUser *user = post.author;
    self.name.text = user[@"username"];
    self.nameInCaption.text = user[@"username"];
    
    self.caption.text = post.caption;
  
    self.likeCount.text = [NSString stringWithFormat:@"%@", post.likeCount];
    self.commentCount.text = [NSString stringWithFormat:@"%@", post.commentCount];
    
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.image.image = [UIImage imageWithData:data];
            // Profile image
            PFFileObject *profileImageFile = post.author[@"profileImage"];
            
            [profileImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    self.profileImage.image = [UIImage imageWithData:data];
                }
            }];
            
                // Timestamp
            // Format createdAt date string
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // Configure the input format to parse the date string
            formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
            // Convert String to Date
            NSDate *date = post.updatedAt;
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
