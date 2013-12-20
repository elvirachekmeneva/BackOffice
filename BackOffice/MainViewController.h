//
//  MainViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tasksTable;
@property (strong, nonatomic) IBOutlet UILabel *cameInInfoLabel;

@end
