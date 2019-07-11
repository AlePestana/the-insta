//
//  PostCell.m
//  TheInsta
//
//  Created by marialepestana on 7/10/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "PostCell.h"
#import "Post.h"

@implementation PostCell

//- (void) refreshDataAtCell:(PostCell*)cell withPost:(Post*)currentPost {
//    
//    PFFileObject *userImageFile = currentPost.image;
//    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//        if (!error) {
//            cell.image.image = [UIImage imageWithData:data];
//        } else {
//            NSLog(@"Image not taken from PFFile");
//        }
//    }];
//    
//    self.name.text = currentPost.userID;
//    self.nameInCaption.text = currentPost.userID;
//    self.caption.text = currentPost.caption;
//    
//}

// viewWillAppear
- (void)setPost:(Post *)post {
    _post = post;
    
    PFFileObject *userImageFile = post.image;
    [userImageFile getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            
            self.name.text = post.author.username;
            self.nameInCaption.text = post.author.username;
            self.caption.text = post.caption;
            self.image.image = [UIImage imageWithData:data];
        } else {
            NSLog(@"Image not taken from PFFile");
        }
    }];
    
    

    
    // Assign values to my properties
//    self.authorName.text = tweet.user.name;
//    NSString *accountBase = @"@";
//    self.authorAccountName.text = [accountBase stringByAppendingString:tweet.user.screenName];
//    self.tweetText.text = tweet.text;
//    self.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
//    self.favoriteCount.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
//
//    self.date.text = tweet.createdAtString;
    
//    NSString *profileImageURL = tweet.user.profileImage;
    
//    self.profileImage.image = nil;
//    NSURL *url = [NSURL URLWithString:profileImageURL];
//    [self.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon.png"]];
//
    
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
