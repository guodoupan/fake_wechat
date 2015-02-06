//
//  LoginViewController.m
//  WeChat
//
//  Created by Qiyuan Liu on 2/5/15.
//  Copyright (c) 2015 liuqiyuan.com. All rights reserved.
//

#import "LoginViewController.h"
#import "ChatViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) PFUser *user;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self) {
        self.title = @"WeChat";
    }
    // Do any additional setup after loading the view from its nib.
    self.passwordTextField.secureTextEntry = true;
}

- (void)chat {
    ChatViewController *vc = [[ChatViewController alloc]init];
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signInButtonClick:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *password = self.passwordTextField.text;
    [PFUser logInWithUsernameInBackground:name password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"%@", @"Signin success");
                                            self.user = user;
                                            [self chat];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"%@", @"Faied login");
                                        }
                                    }];
    
}
- (IBAction)signUpButtonClick:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.nameTextField.text;
    user.password = self.passwordTextField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            NSLog(@"%@", @"Signup success");
            self.user = user;
            [self chat];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
