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

@interface TeamViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    NSTimer* timer;
}
@property (weak, nonatomic) IBOutlet UITableView *teamTable;
@property NSMutableDictionary* teamJson;
@property NSMutableData* mutableTeamData;
@property TeamInfo* teamInfo;
@property NSDictionary* allTeamInfoSorted;
@property UIViewController* personVC;
@property UIStoryboardSegue *showPersonInfoSegue;

- (IBAction)showUserInfo:(id)sender;
@end
