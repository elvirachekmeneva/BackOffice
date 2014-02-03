//
//  TeamViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfo.h"

@interface TeamViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *teamTable;
@property NSMutableDictionary* teamJson;
@property NSMutableData* mutableTeamData;
@property TeamInfo* teamInfo;
@property NSDictionary* allTeamInfoSorted;
@end
