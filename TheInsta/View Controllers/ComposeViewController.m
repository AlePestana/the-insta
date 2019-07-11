//
//  ComposeViewController.m
//  TheInsta
//
//  Created by marialepestana on 7/9/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "ComposeViewController.h"
#import "Post.h"
#import "MBProgressHUD.h"


@interface ComposeViewController () <UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.captionTextView.text = @"start typing";
    self.captionTextView.textColor = [UIColor lightGrayColor];
}


// Function to put placeholder on text view
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.captionTextView.text = @"";
    self.captionTextView.textColor = [UIColor lightGrayColor];
    
    return YES;
}


// Function to put placeholder on text view
-(void) textViewDidChange:(UITextView *)textView {
    
    if(self.captionTextView.text.length == 0) {
        self.captionTextView.textColor = [UIColor lightGrayColor];
        self.captionTextView.text = @"Comment";
        [self.captionTextView resignFirstResponder];
    }
}


// Function to put placeholder on text view
-(void) textViewShouldEndEditing:(UITextView *)textView {
    
    if(self.captionTextView.text.length == 0) {
        self.captionTextView.textColor = [UIColor lightGrayColor];
        self.captionTextView.text = @"Comment";
        [self.captionTextView resignFirstResponder];
    }
}


// Function for tap gesture
- (IBAction)didTap:(id)sender {
    [self.view endEditing:YES];
}


// Function to display camera / all photos to post photo
- (IBAction)didTapImage:(UIButton *)sender {

    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
}


// Delegate method for image picker controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    // UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    
    self.selectedImage  = editedImage;
    self.postImageView.image = [self resizeImage:editedImage withSize:CGSizeMake(200, 200)];
    
    
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Functino to resize images for the postUserImage's required weight
- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


// Function to post
- (IBAction)didPost:(UIBarButtonItem *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage:self.postImageView.image withCaption:self.captionTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil)
            {
                NSLog(@"%@",error);
            } else {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.parentViewController.tabBarController setSelectedIndex:0];
                // [self dismissViewControllerAnimated:YES completion:nil];
            }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
