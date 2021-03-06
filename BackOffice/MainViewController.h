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
#import "TaskDetailsViewController.h"
#import "SwipeCellStyle.h"
#import "TaskTransactions.h"
#import "BackgroundVC.h"
#import "UIColor+Color.h"
#import "UIView+TLMotionEffect.h"
#import "TeamViewController.h"
#import "Reachability.h"

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, JZSwipeCellDelegate>
{
    int count30times;
    BOOL loadingFinish;
    BackgroundVC* background;
    Reachability* reachability;
    
}
- (IBAction)stopAndStart:(id)sender;
- (IBAction)showInfo:(id)sender;
- (BOOL)connected;
- (IBAction)showTeam:(id)sender;
- (IBAction)exitToSignIn:(id)sender;

@property NSString* senderFromSIVC;
@property (weak, nonatomic) IBOutlet UILabel *changedTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *teamButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITableView *tasksTable;
@property (strong, nonatomic) IBOutlet UILabel *cameInInfoLabel;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *teamButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIImageView *whiteCircle;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *taskActivityIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property NSMutableDictionary *json;
@property UIStoryboardSegue *showInfo;
@property UIViewController *infoVC;

@property NSTimer *timer1second;
@property UIStoryboardSegue *signIn;
@property UIViewController *SIVC;
@property UIViewController *taskDetails;
@property NSMutableData *mutableData;
@property NSMutableData* mutableDataWork;
@property NSURLConnection *connnection;
@property NSMutableDictionary *workLog;

@property NSURLConnection *teamConnection;
@property NSMutableData* mutableTeamData;
@property NSMutableDictionary* teamInfo;
@property (strong, nonatomic) IBOutlet UIImageView *onlineCountCircle;

@property (strong, nonatomic) IBOutlet UIImageView *bgrImage;
@property (strong, nonatomic) IBOutlet UIImageView *toneImage;
@property (strong, nonatomic) IBOutlet UILabel *onlineCountLabel;

@end
