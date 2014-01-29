//
//  InfoViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import "InfoViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize json,ds,mutableData,workLog;
@synthesize  list,workInfoTable,headerCell;

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
    workLog = [[NSUserDefaults standardUserDefaults]objectForKey:@"workLog"];
    ds = [[WorkedTableDataSource alloc]initWithDictionary:workLog];

    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    json = [[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    NSLog(@"Json in INFO VC %@", [json valueForKey:@"loginSuccess"]);
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.userNameAndSurname.text = [NSString stringWithFormat:@"%@ %@",
                                    [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"name"],
                                    [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"surname"]];
    self.userDepartment.text = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"department"];
    self.userPosition.text = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"emplPosition"];
    
    NSURL *imageURL = [NSURL URLWithString:[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"photo"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.userPhoto.image = [UIImage imageWithData:imageData];
            self.userPhoto.layer.cornerRadius = 6;
            self.userPhoto.clipsToBounds = YES;
        });
    });
    
    NSString *string =@"Дата";
    [headerCell.contentView addSubview:[self makeCellView:string workHoursString:@"Отработано" totalSumString:@"Заработано"]];
    

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [ds countOfDaysInMonth:[[ds headerNamesArray]objectAtIndex:section]];
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int count = [ds countOfMonth];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *string = [self makeMonthAndYearFromString: [[ds headerNamesArray]objectAtIndex:section]];
    NSString *workHoursString = [NSString stringWithFormat:@"%@(+%@)",
                                 [[ds.allMonthInfo objectForKey:string]objectForKey:@"workHours"],
                                 @"hh:mm"];
                                 //[[ds.allMonthInfo objectForKey:string]objectForKey:@"hh:mm"]];
    NSString *totalSumm = [ds totalSumByMonth:[[ds headerNamesArray]objectAtIndex:section]];
    UIView * header = [self makeCellView:string workHoursString:workHoursString totalSumString:totalSumm];
    
   // [[header subviews][0]  setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:1 alpha:1] ];
    [header setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:0.9]];
    [header setFrame:CGRectMake(0, 0, workInfoTable.frame.size.width, 40)];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];
    NSString *string =[ds dateStringByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];
    
    NSString *workHoursString = [NSString stringWithFormat:@"%@(+%@)",
                                 [ds workedHoursByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section]  andDayNumber:indexPath.row],
                                 @"hh:mm"];
    NSString *totalSumString = [ds totalSumByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section]   andDayNumber:indexPath.row];
    [cell.contentView addSubview:[self makeCellView:string workHoursString:workHoursString totalSumString:totalSumString]];
    return cell;
}

- (UIView*) makeCellView:(NSString*)dateString workHoursString:(NSString*)workHours totalSumString:(NSString*)totalSum {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, workInfoTable.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:11]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label setText:dateString];
    //[label setBackgroundColor:[UIColor greenColor]];
    [view addSubview:label];
    
    UILabel *workHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 85, 30)];
    [workHoursLabel setFont:[UIFont boldSystemFontOfSize:11]];
    workHoursLabel.textAlignment = NSTextAlignmentCenter;
    [workHoursLabel setText:workHours];
    [view addSubview:workHoursLabel];
    
    UILabel *loggedHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 70, 30)];
    [loggedHoursLabel setFont:[UIFont boldSystemFontOfSize:11]];
    loggedHoursLabel.textAlignment = NSTextAlignmentCenter;
    [loggedHoursLabel setText:@"hh:mm"];
    [view addSubview:loggedHoursLabel];
    
    UILabel *coeffLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 30, 30)];
    [coeffLabel setFont:[UIFont boldSystemFontOfSize:11]];
    coeffLabel.textAlignment = NSTextAlignmentCenter;
    [coeffLabel setText:@"1.00"];
    [view addSubview:coeffLabel];
    
    UILabel *zpSummLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 30)];
    [zpSummLabel setFont:[UIFont boldSystemFontOfSize:11]];
    zpSummLabel.textAlignment = NSTextAlignmentCenter;
    [zpSummLabel setText:totalSum];
    //[zpSummLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:zpSummLabel];

    UILabel *kommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 0, 250, 30)];
    [kommentLabel setFont:[UIFont boldSystemFontOfSize:11]];
    kommentLabel.textAlignment = NSTextAlignmentCenter;
    kommentLabel.numberOfLines = 0;
    [kommentLabel setBackgroundColor:[UIColor greenColor]];
    [kommentLabel setText:@"Это комментарий) большой комментарий, многострочный!"];
    
    //[zpSummLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:kommentLabel];
    

    return  view;
}

- (NSString*)makeMonthAndYearFromString:(NSString*)dateString {
    NSString* string = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSDateFormatter*  dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"ru_RU"]];
    NSArray * sss = dateFormatter1.standaloneMonthSymbols ;
    NSString* resultMonth = [sss objectAtIndex:[string integerValue]-1];
    NSString* resultString = [NSString stringWithFormat:@"%@ %@", resultMonth, [dateString substringWithRange:NSMakeRange(0, 4)]];
    return resultString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
