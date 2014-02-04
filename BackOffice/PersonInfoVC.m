//
//  PersonInfoVC.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 04.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "PersonInfoVC.h"

@interface PersonInfoVC ()

@end

@implementation PersonInfoVC

@synthesize departmentLabel, photo, nameLabel, positionLabel, emailButton,callButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"personInfo"];
    NSLog(@"UserInfo %@", userInfo);
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [departmentLabel setText:[userInfo objectForKey:@"departName"]];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                        [userInfo objectForKey:@"firstName"],
                        [userInfo objectForKey:@"lastName"]]];
    [positionLabel setText:[NSString stringWithFormat:@"%@, %@",
                           [userInfo objectForKey:@"position"],
                           [userInfo objectForKey:@"employeestatus"]]];
    [callButton.titleLabel setText:[userInfo objectForKey:@"cellphone"]];
    [emailButton.titleLabel setText:[userInfo objectForKey:@"elvira.chekmeneva@gmail.com"]];
//    [emailButton.titleLabel setText:[userInfo objectForKey:@"email"]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"personInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callButtonPressed:(id)sender {
    NSLog(@"phone number %@",[userInfo objectForKey:@"cellphone"]);
    NSString *phNo = [userInfo objectForKey:@"cellphone"];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    UIAlertView * calert;
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
- (IBAction)emailButtonPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * emailController = [[MFMailComposeViewController alloc] init];
        emailController.mailComposeDelegate = self;
        NSArray* recipients = [NSArray arrayWithObject:@"elvira.chekmeneva@gmail.com"];
        [emailController setSubject:@"theme"];
        [emailController setMessageBody:@"Hi!" isHTML:YES];
        [emailController setToRecipients:recipients];
        [self presentViewController:emailController animated:YES completion:nil];
        
    }
    // Show error if no mail account is active
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must have a mail account in order to send an email" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

- (IBAction)saveContact:(id)sender {
    
}
@end
