//
//  MainViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import "MainViewController.h"
#import "InfoViewController.h"
#import "SignInViewController.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize cameInInfoLabel,json;
@synthesize showInfo,infoVC;
@synthesize timer1second,timeButton;

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    json = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    NSLog(@"Json in MAIN VC %@", [json valueForKey:@"loginSuccess"]);
    
    NSDate* fireDate = [[NSDate alloc]init];
    fireDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"];
    
    count30times = 0;
    
    //[timer1second :fireDate interval:1.0 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
    
    while (YES) {
        while (count30times ==0) {
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        }
        count30times = 0;
        
    }
    
	// Do any additional setup after loading the view.
}



- (void)timerTick:(NSTimer *)timer {
    NSString *nowString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
    NSDate * nowDate = [self makeNSDateFromString:nowString];
    
    if (count30times < 30) {
        static NSDateFormatter *dateFormatter;
        if ((count30times % 2) == 0) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm";
            
            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
        }else {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh mm";
            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
        }
        count30times++;
        NSLog(@"sec %i",count30times);
    } else {
        //проверка инета
        while (![self connected]) {
               count60times = 0;
               [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick60sec:) userInfo:nowDate repeats:YES];
        }
        
        //загрузка нового jsona, когда появился интернет
        SignInViewController *SIVC = [[SignInViewController alloc]init];
        loadingFinish = NO;
        [SIVC connectWithLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"login"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        count30times = 0;
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    loadingFinish = YES;
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)timerTick60sec:(NSTimer *)timer  {
    //NSString *nowString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
    NSDate *nowDate = [timer userInfo];
    if (count60times < 60) {
        static NSDateFormatter *dateFormatter;
        if ((count30times % 2) == 0) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm";
            
            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
        }else {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh mm";
            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
        }
        count60times++;
        NSLog(@"sec %i",count60times);
    } else {
       // время + 1 минута
    }
    
    
    
}


- (NSDate*)makeNSDateFromString:(NSString*)dateString {
    static NSDateFormatter *dateFormatter1;
    if (!dateFormatter1) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = @"hh:mm";
    }
    return [dateFormatter1 dateFromString:dateString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}



- (IBAction)stopAndStart:(id)sender {
}

- (IBAction)showInfo:(id)sender {
    showInfo = [[UIStoryboardSegue alloc]initWithIdentifier:@"showInfo" source:self destination:infoVC];
    [self performSegueWithIdentifier:@"showInfo" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showInfo"]) {

        InfoViewController *infoVC = [segue destinationViewController];
        //[infoVC setJson:json];
    }
}
@end
