//
//  TeamViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

@synthesize teamTable,teamJson,mutabelTeamData,teamInfo;
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
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
    
    //NSMutableDictionary* monthInfoDictionary = [ds getInfoByMonth:section];
    
//    UILabel *onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, teamTable.frame.size.width, 20)];
//    [onlineLabel setFont:[UIFont boldSystemFontOfSize:11]];
//        onlineLabel.textAlignment = NSTextAlignmentLeft;
////    [onlineLabel setBackgroundColor:[UIColor greenColor]];
//    if (section < teamTable.numberOfSections/2) {
//        [onlineLabel setTextColor:[UIColor blueColor]];
//        [onlineLabel setText:@"OnLine"];
//    } else {
//        [onlineLabel setTextColor:[UIColor redColor]];
//        [onlineLabel setText:@"OffLine"];
//    }
//    [view addSubview:onlineLabel];
  
    UILabel *departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, teamTable.frame.size.width, 20)];
    [departmentLabel setFont:[UIFont boldSystemFontOfSize:11]];
    departmentLabel.textAlignment = NSTextAlignmentLeft;
    [departmentLabel setText:@"dep.name"];
//    [departmentLabel setBackgroundColor:[UIColor greenColor]];
    [view addSubview:departmentLabel];
    
    return  view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
    }
    
    UIButton* phone = [UIButton buttonWithType:UIButtonTypeCustom];
    [phone setImage:[UIImage imageNamed:@"phone1.png"] forState:UIControlStateNormal];
    phone.frame = CGRectMake(0, 0, 15, 15);
    phone.userInteractionEnabled = YES;
    [phone addTarget:self action:@selector(didTapInfoButton:) forControlEvents:UIControlEventTouchDown];
    cell.accessoryView = phone;
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if (indexPath.section == 0) {
        [[cell textLabel]setText:@"I'm here!"];
    } else {
         [[cell textLabel]setText:@"I'm home..."];
    }
    return cell;
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
        mutabelTeamData = [[NSMutableData alloc] init];
    }
    
    
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutabelTeamData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutabelTeamData appendData:data];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    teamJson = [NSJSONSerialization JSONObjectWithData:mutabelTeamData options:kNilOptions error:nil];
    NSLog(@"team json %@",teamJson);
    teamInfo = [[TeamInfo alloc]initWithDictionary:teamJson];
    [teamTable reloadData];
}



@end
