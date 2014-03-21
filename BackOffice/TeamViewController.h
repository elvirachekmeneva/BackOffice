//
//  TeamViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfo.h"
#import "PersonInfoVC.h"
#import "BackgroundVC.h"

@interface TeamViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    NSTimer* timer;
    BackgroundVC* background;
}

@property (strong, nonatomic) IBOutlet UIImageView *bgrImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userPhoto;
@property (strong, nonatomic) IBOutlet UITableView *teamTable;
@property (strong, nonatomic) IBOutlet UILabel *onlineCount;
@property (strong, nonatomic) IBOutlet UILabel *allTeamCount;
@property (strong, nonatomic) IBOutlet UIImageView *onlineIcon;
@property NSMutableDictionary* teamJson;
@property NSMutableData* mutableTeamData;
@property TeamInfo* teamInfo;
@property NSDictionary* allTeamInfoSorted;
//@property UIViewController* personVC;
@property UIStoryboardSegue *showPersonInfoSegue;

- (IBAction)showUserInfo:(id)sender;
@end
