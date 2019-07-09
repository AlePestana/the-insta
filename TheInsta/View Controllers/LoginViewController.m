//
//  LoginViewController.m
//  TheInsta
//
//  Created by marialepestana on 7/8/19.
//  Copyright © 2019 marialepestana. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (weak, nonatomic) IBOutlet UIButton *signUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *logInLabel;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signUpLabel.layer.cornerRadius = 8;
    self.logInLabel.layer.cornerRadius = 8;
//    self.signUpLabel.layer.borderColor = (UIColor.lightGrayColor);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
