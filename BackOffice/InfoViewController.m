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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [ds countOfDaysInMonth:[[ds headerNamesArray]objectAtIndex:section]];
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int count = [ds countOfMonth];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
    }
    
    
    NSString *string =[ds dateStringByMonth:[[ds headerNamesArray]objectAtIndex:indexPath.section] andDayNumber:indexPath.row];
    UIView *view = [self makeDateViewColumnWithString:string];
    [cell.contentView addSubview:view];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *string =[[ds headerNamesArray]objectAtIndex:section];
    UIView *view = [self makeDateViewColumnWithString:string];
    return view;
}

- (UIView*) makeDateViewColumnWithString:(NSString*)dateString {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, workInfoTable.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 70, 28)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = dateString;
    [label setText:string];
    //[label setBackgroundColor:[UIColor greenColor]];
    [view addSubview:label];
    return  view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
