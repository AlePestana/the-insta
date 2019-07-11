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
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            
            self.name.text = post.author.username;
            self.nameInCaption.text = post.author.username;
            self.caption.text = post.caption;
            self.image.image = [UIImage imageWithData:data];
            
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
