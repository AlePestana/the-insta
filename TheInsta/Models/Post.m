//
//  Post.m
//  TheInsta
//
//  Created by marialepestana on 7/9/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "Post.h"


@implementation Post

    @dynamic postID;
    @dynamic userID;
    @dynamic author;
    @dynamic caption;
    @dynamic image;
    @dynamic likeCount;
    @dynamic commentCount;
    @dynamic favorited;


    + (nonnull NSString *)parseClassName {
        return @"Post";
    }

// Function to post a post's image on Parse's database
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    // withLikeCount: (int nul)likeCount
        // call likeCount here
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}


// Function to get image
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


// Function to update like count on the Parse database
+ (void) updateLikeCount: (NSNumber * _Nullable) likeCount withObjectID: ( NSString * _Nullable ) objectID withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:objectID block:^(PFObject *Post, NSError *error) {
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        Post[@"likeCount"] = likeCount;
        [Post saveInBackground];
        
    }];
}


// Function to post a user's profile image on Parse's database
+ (void) postProfileUserImage: ( UIImage * _Nullable )profileImage withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    
    NSData *imageData = UIImagePNGRepresentation(profileImage);
    
    [PFUser currentUser][@"profileImage"] = [PFFileObject fileObjectWithName:@"profileImage.png" data:imageData];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

@end
