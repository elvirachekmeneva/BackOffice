//
//  ViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UISwitch *saveOrNot;
@property (weak, nonatomic) IBOutlet UITextField *userLogin;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
- (IBAction)signInButtonPressed:(id)sender;
- (IBAction)saveValueChenged:(id)sender;

@property NSURLConnection *connection;
@property NSString *login;
@property NSString *password;
@end
