//
//  SignUpViewController.m
//  TheInsta
//
//  Created by marialepestana on 7/8/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *signUpLabel;


@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signUpLabel.layer.cornerRadius = 8;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    newUser.email = self.emailTextField.text;
    newUser.password = self.passwordTextField.text;

    
    
    
//    if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
//        do {
//            // --------------------------> Alert controller
//            // Alert controller setup
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm Password" message:@"Please enter a new password." preferredStyle:(UIAlertControllerStyleAlert)];
//
//            // create an OK action
//            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                // handle response here.
//                self.passwordTextField.text = nil;
//                self.confirmPasswordTextField.text = nil;
//            }];
//
//            // add the OK action to the alert controller
//            [alert addAction:okAction];
//
//
////            self.passwordTextField.text = nil;
////            self.confirmPasswordTextField.text = nil;
//
//
//            [self presentViewController:alert animated:YES completion:^{}];
//            // --------------------------> Alert controller
//
//        } while([self.passwordTextField.text length] == 0);
//
//
//    }
    
    
    
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            // NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)didSignUp:(UIButton *)sender {
    [self registerUser];
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