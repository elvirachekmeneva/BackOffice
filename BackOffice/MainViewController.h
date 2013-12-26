//
//  MainViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    int count30times,count60times;
    BOOL loadingFinish;
}

- (IBAction)stopAndStart:(id)sender;
- (IBAction)showInfo:(id)sender;
- (BOOL)connected;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UITableView *tasksTable;
@property (strong, nonatomic) IBOutlet UILabel *cameInInfoLabel;
@property NSDictionary *json;
@property UIStoryboardSegue *showInfo;
@property UIViewController *infoVC;
@property NSTimer *timer1second;

@end
