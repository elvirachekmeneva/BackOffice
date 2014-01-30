//
//  InfoViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkedTableDataSource.h"

@interface InfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property NSDictionary *json;
@property (weak, nonatomic) IBOutlet UILabel *userNameAndSurname;
@property (weak, nonatomic) IBOutlet UILabel *userDepartment;
@property (weak, nonatomic) IBOutlet UILabel *userPosition;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property WorkedTableDataSource* ds;
@property NSMutableData *mutableData;
@property NSMutableDictionary *workLog;
@property NSArray* list;
@property (weak, nonatomic) IBOutlet UITableView *workInfoTable;

@property UIView* cellView;

@end
