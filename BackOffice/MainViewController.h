//
//  MainViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SignInViewController.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int count30times;
    BOOL loadingFinish;
    
}

- (IBAction)stopAndStart:(id)sender;
- (IBAction)showInfo:(id)sender;
- (BOOL)connected;

- (IBAction)exit:(id)sender;
- (IBAction)exitToSignIn:(id)sender;
@property NSString* senderFromSIVC;
@property (weak, nonatomic) IBOutlet UILabel *changedTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITableView *tasksTable;
@property (strong, nonatomic) IBOutlet UILabel *cameInInfoLabel;
@property NSDictionary *json;
@property UIStoryboardSegue *showInfo;
@property UIViewController *infoVC;

@property NSTimer *timer1second;
@property UIStoryboardSegue *signIn;
@property UIViewController *SIVC;
@property NSMutableData *mutableData;

@end
