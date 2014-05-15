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

@synthesize teamTable,teamJson,mutableTeamData,teamInfo,allTeamInfoSorted,showPersonInfoSegue;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    NSURL *imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"data"][@"data"][@"user"][@"photo"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.userPhoto.image = image;
            self.userPhoto.layer.cornerRadius = 15.5;
            self.userPhoto.clipsToBounds = YES;
        });
    });
    
    teamJson = [[NSUserDefaults standardUserDefaults]objectForKey:@"teamInfo"];
    teamInfo = [[TeamInfo shared] initWithDictionary:teamJson];
    allTeamInfoSorted = [[TeamInfo shared] getAllTeamInfo];
//    teamInfo = [[TeamInfo alloc]initWithDictionary:teamJson];
//    [self getTeamInfoFromServer];
//    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(reloadData:) userInfo:nil repeats:YES];
    
    background = [[BackgroundVC alloc] initForView:VC_NAME_TEAM];
    [self.bgrImageView addSubview:background.backGroundImage];
    [self.bgrImageView sendSubviewToBack:background.backGroundImage];

    self.allTeamCount.text = [NSString stringWithFormat:@"%@/%@", [[TeamInfo shared] onlineCount],[[TeamInfo shared] allTeamCount]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

//    self.navigationController.navigationBar.backItem.title = @"";

    [timer invalidate];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.backItem.title = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
}


//-(void)reloadData:(NSTimer *)timer {
//    [self getTeamInfoFromServer];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[TeamInfo shared] getDepartmentsKeys]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * header = [self makeHeaderViewForSection:section];
    [header setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.95 alpha:0.95]];
    return header;
}

- (UIView*) makeHeaderViewForSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTable.frame.size.width, 40)];
  
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, teamTable.frame.size.width - 50, 40)];
    [departmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16.0]];
    [departmentLabel setTextColor:[UIColor whiteColor]];
    departmentLabel.textAlignment = NSTextAlignmentLeft;
    departmentLabel.adjustsFontSizeToFitWidth = YES;
    departmentLabel.minimumScaleFactor = 0.5;
    NSString* depKey = [[[TeamInfo shared] getDepartmentsKeys]objectAtIndex:section];
    [departmentLabel setText:[[allTeamInfoSorted objectForKey:depKey]objectForKey:@"departmentName"]];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(teamTable.frame.size.width - 50, 0, 50, 40)];
    [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15.0]];
    [countLabel setTextColor:[UIColor whiteColor]];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.adjustsFontSizeToFitWidth = YES;
    countLabel.minimumScaleFactor = 0.5;
    countLabel.text = [NSString stringWithFormat:@"%@/%@",[[TeamInfo shared] onlineCountForDepartment:depKey],[[TeamInfo shared] allTeamCountForDepartment:depKey]];
    
//    [departmentLabel setBackgroundColor:[UIColor greenColor]];
    [departmentLabel setBackgroundColor:[background toneColorForDepartment:depKey]];
    [view addSubview:departmentLabel];
    [countLabel setBackgroundColor:[background toneColorForDepartment:depKey]];
    [view addSubview:countLabel];
    [view setBackgroundColor:[background toneColorForDepartment:depKey]];
    view.alpha = 0.55;

    return  view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString* devKey = [[[TeamInfo shared] getDepartmentsKeys]objectAtIndex:section];
    NSInteger rowCount = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] + [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell * cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSString* devKey = [[[TeamInfo shared] getDepartmentsKeys]objectAtIndex:indexPath.section];
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > indexPath.row) {
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"workedTime"];
        NSString* position = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"position"];
        NSString* empStatus = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"employeestatus"];
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        [cell.position setText:[NSString stringWithFormat:@"%@, %@",position,empStatus]];

        
        
        [cell.onlineIcon setImage:[UIImage imageNamed:@"team-online-icon.png"]];
        
        [cell.bgrImage setBackgroundColor:[background toneColorForUser:[[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"userLogin"]]];
        [cell.bgrImage setAlpha:0.3];
        
        cell.onlineStartTime.alpha = 0.7;
        cell.onlineTimeLabel.alpha = 1;
        [cell.onlineTimeLabel setText:workedTime];
        cell.onlineStartTime.text = allTeamInfoSorted[devKey][@"online"][indexPath.row][@"startTime"];
        cell.offlineEndTime.alpha = 0;
        cell.offlineStartTime.alpha = 0;
        cell.offlineTimeLabel.alpha = 0;
        
//        cell.onlineIcon.frame = CGRectMake(2, 11, 26, 57);
//        cell.onlineIcon.contentMode = UIViewContentModeScaleToFill; // This determines position of image
//        cell.onlineIcon.clipsToBounds = YES;
//        [cell.timeLabel setBackgroundColor:[UIColor greenColor]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",
                                                                             [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"userID"]]];
        
        
            if ([UIImage imageWithContentsOfFile:path]){
                UIImage* image = [UIImage imageWithContentsOfFile:path];
                cell.photo.image = image;
                cell.photo.layer.cornerRadius = 30;
                cell.photo.clipsToBounds = YES;
            }else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
                    NSString * photoURLString = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row]objectForKey:@"imageURL"];
                    UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
                    cell.photo.image = image;
                    cell.photo.layer.cornerRadius = 30;
                    cell.photo.clipsToBounds = YES;
                    
                    NSData* data = UIImagePNGRepresentation(image);
                    [data writeToFile:path atomically:YES];
                });
            }
        
        cell.contentView.alpha = 1;
        
    } else {
        NSInteger offLineNumber = indexPath.row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        
        NSString* firstName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"firstName"];
        NSString* lastName = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"lastName"];
        NSString* workedTime = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"workedTime"];
        NSString* position = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"position"];
        NSString* empStatus = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"employeestatus"];
        
        [cell.nameLabel setText:[NSString stringWithFormat:@"%@ %@",firstName,lastName]];
        [cell.position setText:[NSString stringWithFormat:@"%@, %@",position,empStatus]];
        [cell.onlineIcon setImage:[UIImage imageNamed:@"team-offline-2.png"]];
        
        cell.onlineStartTime.alpha = 0;
        cell.onlineTimeLabel.alpha = 0;
        [cell.offlineTimeLabel setText:workedTime];
        cell.offlineStartTime.text = [NSString stringWithFormat:@"%@ %@", allTeamInfoSorted[devKey][@"offline"][offLineNumber][@"startDate"], allTeamInfoSorted[devKey][@"offline"][offLineNumber][@"startTime"]];
        cell.offlineEndTime.text = allTeamInfoSorted[devKey][@"offline"][offLineNumber][@"endTime"];
        cell.offlineEndTime.alpha = 1;
        cell.offlineStartTime.alpha = 1;
        cell.offlineTimeLabel.alpha = 0.7;
        
        
        [cell.bgrImage setBackgroundColor:[background toneColorForUser:[[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"userLogin"]]];
        [cell.bgrImage setAlpha:0.3];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",
                           [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"userID"] ] ];
        if ([UIImage imageWithContentsOfFile:path]){
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            cell.photo.image = image;
            cell.photo.layer.cornerRadius = 30;
            cell.photo.clipsToBounds = YES;
        }else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{

                NSString * photoURLString = [[[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber]objectForKey:@"imageURL"];
                UIImage* image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURLString]]];
                cell.photo.image = image;
                cell.photo.layer.cornerRadius = 30;
                cell.photo.clipsToBounds = YES;

                NSData* data = UIImagePNGRepresentation(image);
                [data writeToFile:path atomically:YES];
            });
        }
        cell.contentView.alpha = 0.5;

    }
    
    
    cell.personInfoButton.tag = [self makeButtonTagByIndexPath:indexPath];
    [cell.personInfoButton  addTarget:self action:@selector(personInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (NSInteger) makeButtonTagByIndexPath:(NSIndexPath*) indexPath {
    NSInteger result = 100 * indexPath.section + indexPath.row;
    return result;
}

- (NSArray*) makeIndexPathByTag: (NSInteger) tag {
    int sectionInt = tag / 100;
    NSString* section = [NSString stringWithFormat:@"%d",sectionInt];
    
    int rowInt  = tag % 100;
    NSString* row = [NSString stringWithFormat:@"%d",rowInt];
    
    NSArray* resultArray = [NSArray arrayWithObjects:section,row, nil];
    return resultArray;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* userInfo;
    NSString* devKey = [[teamInfo getDepartmentsKeys]objectAtIndex:indexPath.section];
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > indexPath.row) {
        userInfo = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:indexPath.row];
    } else {
        NSInteger offLineNumber = indexPath.row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        userInfo = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber];
    }
    NSLog(@"UserInfo %@", userInfo );
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"personInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   

}

- (void)personInfoButtonPressed:(UIButton*)button {
    int tag = button.tag;
    NSLog(@"button tag %d",tag);
    NSInteger section = [[self makeIndexPathByTag:tag][0] integerValue];
    NSInteger row = [[self makeIndexPathByTag:tag][1] integerValue];
    NSString* devKey = [[[TeamInfo shared] getDepartmentsKeys]objectAtIndex:section];
    
    NSDictionary* userInfo;
    if ([[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]count] > row) {
        userInfo = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"]objectAtIndex:row];
    } else {
        NSInteger offLineNumber = row - [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"online"] count];
        userInfo = [[[allTeamInfoSorted objectForKey:devKey]objectForKey:@"offline"]objectAtIndex:offLineNumber];
    }
    NSLog(@"UserInfo %@", userInfo );
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"personInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIView*) makeCellViewForIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, teamTable.frame.size.width, 20)];
    
    NSString* devKey = [[[TeamInfo shared] getDepartmentsKeys]objectAtIndex:indexPath.section];
    
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

//- (void) getTeamInfoFromServer {
//    NSString *urlStringWork = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.online.json.php?json=1&tst=1&dev=1&web=1"];
//    NSURL *urlWork = [NSURL URLWithString:urlStringWork];
//    NSMutableURLRequest *requestWork = [NSMutableURLRequest requestWithURL:urlWork
//                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
//    [requestWork setHTTPMethod: @"GET"];
//    
//    NSURLConnection *connectionWork = [[NSURLConnection alloc] initWithRequest:requestWork delegate:self];
//    if (connectionWork)
//    {
//        mutableTeamData = [[NSMutableData alloc] init];
//    }
//    
//    
//}
//
//-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
//{
//    [mutableTeamData setLength:0];
//}
//
//-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [mutableTeamData appendData:data];
//}
//
//
//
//- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//    teamJson = [NSJSONSerialization JSONObjectWithData:mutableTeamData options:kNilOptions error:nil];
//    //NSLog(@"team json %@",teamJson);
//    
//    teamInfo = [[TeamInfo alloc]initWithDictionary:teamJson];
//    allTeamInfoSorted = [teamInfo getAllTeamInfo];
//    [teamTable reloadData];
//    self.allTeamCount.text = [NSString stringWithFormat:@"%@/%@", [teamInfo onlineCount],[teamInfo allTeamCount]];
//
//    NSLog(@" Team Data loaded!");
//
//    
//}

- (IBAction)showUserInfo:(id)sender {
    NSLog(@"Show info Button Pressed!!!!");
    
   // showPersonInfoSegue = [[UIStoryboardSegue alloc]initWithIdentifier:@"showPerson" source:self destination:personVC];
//    [self performSegueWithIdentifier:@"personInfoVC" sender:nil];
}

- (IBAction)openBash:(id)sender{
    NSLog(@"Show bash Button Pressed!!!!");

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"personVC"]) {
        PersonInfoVC *pvc = [segue destinationViewController];
        
    } else if ([[segue identifier] isEqualToString:@"showBash"]) {
        BashSAVC *bVC = [segue destinationViewController];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
