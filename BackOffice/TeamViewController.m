//
//  TeamViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TeamViewController.h"
#import "CustomCell.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

@synthesize teamTable,teamJson,mutableTeamData,teamInfo,allTeamInfoSorted;
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
    teamJson = [[NSUserDefaults standardUserDefaults]objectForKey:@"teamInfo"];
    
    teamInfo = [[TeamInfo alloc]initWithDictionary:teamJson];
    [self getTeamInfoFromServer];
	// Do any additional setup after loading the view.
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didTapInfoButton:(UIButton*)button {
    UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"You can't call" message:@"Phone number doesn't exist yet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [allert show];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[teamInfo getDepartmentsKeys]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [self makeHeaderViewForSection:section];
    [header setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:0.95]];
    return header;
}

- (UIView*) makeHeaderViewForSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTable.frame.size.width, 30)];
  
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, teamTable.frame.size.width, 30)];
    [departmentLabel setFont:[UIFont boldSystemFontOfSize:13]];
    departmentLabel.textAlignment = NSTextAlignmentCenter;
    departmentLabel.adjustsFontSizeToFitWidth = YES;
    departmentLabel.minimumScaleFactor = 0.5;
    NSString* depKey = [[teamInfo getDepartmentsKeys]objectAtIndex:section];
    [departmentLabel setText:[[allTeamInfoSorted objectForKey:depKey]objectForKey:@"departmentName"]];
//    [departmentLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:departmentLabel];
    
    
    
    return  view;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 40;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:section];
    NSInteger rowCount = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] + [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleSubtitle
//                             reuseIdentifier:@"cell"];
    
    
    
    CustomCell * cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:indexPath.section];
    NSURL *imageURL;
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > indexPath.row) {
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"workedTime"];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        
        [cell.timeLabel setText:workedTime];
        [cell.timeLabel setBackgroundColor:[UIColor greenColor]];
        
        //[nameLabel setTextColor:[UIColor greenColor]];
        imageURL = [NSURL URLWithString:[[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"imageURL"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photo.image = [UIImage imageWithData:imageData];
                cell.photo.layer.cornerRadius = 6;
               // cell.photo.clipsToBounds = YES;

            });
        });
        
    } else {
        NSInteger offLineNumber = indexPath.row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"workedTime"];
        NSString* imageURL = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"imageURL"];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        
        [cell.timeLabel setText:workedTime];
        [cell.timeLabel setBackgroundColor:[UIColor grayColor]];
        imageURL = [NSURL URLWithString:[[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"imageURL"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.photo.image = [UIImage imageWithData:imageData];
                cell.photo.layer.cornerRadius = 6;
               // cell.photo.clipsToBounds = YES;
                
            });
        });

    }
    
//    UIView* cellView = [self makeCellViewForIndexPath:indexPath];
//    [cell.contentView addSubview:cellView];
    
//    UIButton* phone = [UIButton buttonWithType:UIButtonTypeCustom];
//    [phone setImage:[UIImage imageNamed:@"phone1.png"] forState:UIControlStateNormal];
//    phone.frame = CGRectMake(0, 0, 15, 15);
//    phone.userInteractionEnabled = YES;
//    [phone addTarget:self action:@selector(didTapInfoButton:) forControlEvents:UIControlEventTouchDown];
//    cell.accessoryView = phone;
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    
    
    return cell;
}

- (UIView*) makeCellViewForIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTable.frame.size.width, 20)];
    
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:indexPath.section];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, teamTable.frame.size.width, 20)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:13]];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.minimumScaleFactor = 0.5;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 46, 40)];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:13]];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > indexPath.row) {
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"workedTime"];
        [nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        [nameLabel setTextColor:[UIColor greenColor]];
        
        [timeLabel setText:workedTime];
        [timeLabel setBackgroundColor:[UIColor greenColor]];
    } else {
        NSInteger offLineNumber = indexPath.row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"workedTime"];
        [nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        
        [timeLabel setText:workedTime];
        [timeLabel setBackgroundColor:[UIColor grayColor]];
    }
    [view addSubview:timeLabel];
    [view addSubview:nameLabel];
    return view;

}

- (void) getTeamInfoFromServer {
    NSString *urlStringWork = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.online.json.php?json=1&tst=1&dev=1&web=1"];
    NSURL *urlWork = [NSURL URLWithString:urlStringWork];
    NSMutableURLRequest *requestWork = [NSMutableURLRequest requestWithURL:urlWork
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [requestWork setHTTPMethod: @"GET"];
    
    NSURLConnection *connectionWork = [[NSURLConnection alloc] initWithRequest:requestWork delegate:self];
    if (connectionWork)
    {
        mutableTeamData = [[NSMutableData alloc] init];
    }
    
    
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableTeamData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableTeamData appendData:data];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    teamJson = [NSJSONSerialization JSONObjectWithData:mutableTeamData options:kNilOptions error:nil];
    NSLog(@"team json %@",teamJson);
    
    teamInfo = [[TeamInfo alloc]initWithDictionary:teamJson];
    allTeamInfoSorted = [teamInfo getAllTeamInfo];
    [teamTable reloadData];

    
}



@end
