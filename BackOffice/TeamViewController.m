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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:section];
    NSInteger rowCount = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] + [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell * cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:indexPath.section];
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > indexPath.row) {
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"workedTime"];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        
        [cell.timeLabel setText:workedTime];
        [cell.timeLabel setBackgroundColor:[UIColor greenColor]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",
                                                                             [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"userID"]]];
        if ([UIImage imageWithContentsOfFile:path]){
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            cell.photo.image = image;
            cell.photo.layer.cornerRadius = 6;
        }else {
            NSString * photoURLString = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"imageURL"];
            UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
            cell.photo.image = image;
            cell.photo.layer.cornerRadius = 6;
            
            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }
        
    } else {
        NSInteger offLineNumber = indexPath.row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"workedTime"];
        
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        
        [cell.timeLabel setText:workedTime];
        [cell.timeLabel setBackgroundColor:[UIColor grayColor]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",
                           [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"userID"] ] ];
        if ([UIImage imageWithContentsOfFile:path]){
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            cell.photo.image = image;
            cell.photo.layer.cornerRadius = 6;
        }else {
            NSString * photoURLString = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"imageURL"];
            UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
            cell.photo.image = image;
            cell.photo.layer.cornerRadius = 6;

            NSData* data = UIImagePNGRepresentation(image);
            [data writeToFile:path atomically:YES];
        }

    }
    
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
