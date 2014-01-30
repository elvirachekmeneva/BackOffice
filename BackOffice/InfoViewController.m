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
@synthesize  list,workInfoTable;

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

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];}

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
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    [workInfoTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [ds countOfDaysInMonth:[[ds headerNamesArray]objectAtIndex:section]];
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int count = [ds countOfMonth];
    return count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [self makeHeaderViewForSection:section];
    [header setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:0.95]];
    return header;
}

- (UIView*) makeHeaderViewForSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, workInfoTable.frame.size.width, 60)];
    NSString *dateString = [self makeMonthAndYearFromString: [[ds headerNamesArray]objectAtIndex:section]];
    NSString *workHours = [NSString stringWithFormat:@"Отработано: %@ ч.",
                                 [ds workHoursByMonth:[[ds headerNamesArray]objectAtIndex:section]]];
    NSString *loggedHours = [NSString stringWithFormat:@"Залогировано: %@ ч.", [ds loggedHoursByMonth:[[ds headerNamesArray]objectAtIndex:section]]];
    NSString *totalSumm = [NSString stringWithFormat:@"%@ руб.",[ds totalSumByMonth:[[ds headerNamesArray]objectAtIndex:section]]];
    NSString *okladAndPremSumm = [NSString stringWithFormat:@"%@ руб.",[ds okladAndPremSumByMonth:[[ds headerNamesArray]objectAtIndex:section]]];
    NSString *addSumm = [NSString stringWithFormat:@"%@ руб.",[ds addSumByMonth:[[ds headerNamesArray]objectAtIndex:section]]];

    
    

    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 130, 20)];
    [monthLabel setFont:[UIFont boldSystemFontOfSize:11]];
    monthLabel.textAlignment = NSTextAlignmentLeft;
    [monthLabel setText:dateString];
//    [monthLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:monthLabel];
    
    UILabel *workHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 20, 130, 20)];
    [workHoursLabel setFont:[UIFont boldSystemFontOfSize:11]];
    workHoursLabel.textAlignment = NSTextAlignmentLeft;
//    [workHoursLabel setBackgroundColor:[UIColor yellowColor]];
    [workHoursLabel setText:workHours];
    [view addSubview:workHoursLabel];
    
    UILabel *loggedHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 40, 130, 20)];
    [loggedHoursLabel setFont:[UIFont boldSystemFontOfSize:11]];
    loggedHoursLabel.textAlignment = NSTextAlignmentLeft;
//    [loggedHoursLabel setBackgroundColor:[UIColor greenColor]];
    [loggedHoursLabel setText:loggedHours];
    [view addSubview:loggedHoursLabel];
    
    UILabel *zpSummLabel = [[UILabel alloc] initWithFrame:CGRectMake(workInfoTable.frame.size.width - 180, 0, 180, 20)];
    [zpSummLabel setFont:[UIFont boldSystemFontOfSize:11]];
    zpSummLabel.textAlignment = NSTextAlignmentRight;
    [zpSummLabel setText:totalSumm];
//    [zpSummLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:zpSummLabel];
    
    UILabel *oklPremLabel = [[UILabel alloc] initWithFrame:CGRectMake(workInfoTable.frame.size.width - 180, 20, 180, 20)];
    [oklPremLabel setFont:[UIFont boldSystemFontOfSize:11]];
    oklPremLabel.textAlignment = NSTextAlignmentRight;
    [oklPremLabel setText:[NSString stringWithFormat:@"Оклад + Премия  %@",okladAndPremSumm]];
//    [oklPremLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:oklPremLabel];
    
    UILabel *bonusLabel = [[UILabel alloc] initWithFrame:CGRectMake(workInfoTable.frame.size.width - 180, 40, 180, 20)];
    [bonusLabel setFont:[UIFont boldSystemFontOfSize:11]];
    bonusLabel.textAlignment = NSTextAlignmentRight;
    [bonusLabel setText:[NSString stringWithFormat:@"Переработка  %@",addSumm]];
//    [bonusLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:bonusLabel];
    
//    UILabel *coeffLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 30, 30)];
//    [coeffLabel setFont:[UIFont boldSystemFontOfSize:11]];
//    coeffLabel.textAlignment = NSTextAlignmentCenter;
//    [coeffLabel setText:@"1.00"];
//    [view addSubview:coeffLabel];
    
    
    
    return  view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[ds commentByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row] isEqualToString:@""]){
        return 60;
    }else {
        return 110;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"cell"];
    UIView* cellView = [self makeCellViewForIndexPath:indexPath];
    [cell.contentView addSubview:cellView];
    DaySuccess success = [ds successDayByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section]  andDayNumber:indexPath.row];
    if (success == Success) {
        [cell setBackgroundColor:[UIColor colorWithRed:0.8 green:1 blue:0.8 alpha:1]];
    } else if (success == Fail) {
        [cell setBackgroundColor:[UIColor colorWithRed:1 green:0.8 blue:0.8 alpha:1]];
    }
        return cell;
}

- (UIView*) makeCellViewForIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, workInfoTable.frame.size.width, 30)];
    
    NSString *dateString =[[ds dateStringByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row] substringWithRange:NSMakeRange(8, 2)];
    
    NSString *workHoursString = [NSString stringWithFormat:@"%@(+%@)",
                                 [ds workedHoursByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row],
                                 [ds addHoursByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row]];
    NSString *totalSumString = [ds totalSumByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section]   andDayNumber:indexPath.row];
    
    NSString *startEndString = [ds startAndEndTimeByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];
    NSString *commentString = [ds commentByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];
    NSString *loggedHoursString = [ds loggedHoursByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];
    NSString *coeffString = [ds coeffByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];


    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [label setText:dateString];
    //[label setBackgroundColor:[UIColor greenColor]];
    [view addSubview:label];
    
    UILabel *startEndLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 90, 30)];
    [startEndLabel setFont:[UIFont boldSystemFontOfSize:14]];
    startEndLabel.textAlignment = NSTextAlignmentLeft;
//    [startEndLabel setBackgroundColor:[UIColor yellowColor]];
    [startEndLabel setText:startEndString];
    [view addSubview:startEndLabel];
    
    UILabel *workHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 90, 30)];
    [workHoursLabel setFont:[UIFont boldSystemFontOfSize:14]];
    workHoursLabel.textAlignment = NSTextAlignmentLeft;
//    [workHoursLabel setBackgroundColor:[UIColor redColor]];
    [workHoursLabel setText:workHoursString];
    [view addSubview:workHoursLabel];
    
    UILabel *loggedHoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 70, 30)];
    [loggedHoursLabel setFont:[UIFont boldSystemFontOfSize:14]];
    loggedHoursLabel.textAlignment = NSTextAlignmentCenter;
//    [loggedHoursLabel setBackgroundColor:[UIColor yellowColor]];
    [loggedHoursLabel setText:loggedHoursString];
    [view addSubview:loggedHoursLabel];
    
    UILabel *coeffLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 30, 70, 30)];
    [coeffLabel setFont:[UIFont boldSystemFontOfSize:14]];
    coeffLabel.textAlignment = NSTextAlignmentCenter;
//    [coeffLabel setBackgroundColor:[UIColor greenColor]];
    [coeffLabel setText:coeffString];
    [view addSubview:coeffLabel];
    
    UILabel *zpSummLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 30)];
    [zpSummLabel setFont:[UIFont boldSystemFontOfSize:14]];
    zpSummLabel.textAlignment = NSTextAlignmentLeft;
    [zpSummLabel setText:totalSumString];
//    [zpSummLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:zpSummLabel];

    UILabel *kommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, workInfoTable.frame.size.width - 40, 50)];
    [kommentLabel setFont:[UIFont boldSystemFontOfSize:14]];
    kommentLabel.textAlignment = NSTextAlignmentCenter;
    kommentLabel.numberOfLines = 0;
//    [kommentLabel setBackgroundColor:[UIColor greenColor]];
    kommentLabel.adjustsFontSizeToFitWidth = YES;
    kommentLabel.minimumScaleFactor = 0.5;
    [kommentLabel setText:commentString];
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
