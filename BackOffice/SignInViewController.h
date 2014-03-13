//
//  ViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(MD5)
@end

@interface SignInViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *invalidLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UISwitch *saveOrNot;
@property (weak, nonatomic) IBOutlet UITextField *userLogin;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (strong, nonatomic) IBOutlet UIButton *forgotButton;

- (IBAction)signInButtonPressed:(id)sender;
- (IBAction)saveValueChenged:(id)sender;

- (void) connectWithLogin:(NSString*)login password:(NSString*)password;
- (NSString*)MD5;

@property UIViewController *mainVC;
@property NSString *login;
@property NSString *password;
@property NSMutableData *mutableData;
@property NSMutableDictionary *json;
@end
