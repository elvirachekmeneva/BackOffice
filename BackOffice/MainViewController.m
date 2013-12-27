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
@synthesize SIVC,mutableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [timer1second invalidate];
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

    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    NSLog(@"text text text text text");
    
	// Do any additional setup after loading the view.
}

- (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)timerTick:(NSTimer *)timer {
    NSString *nowString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
    NSDate * nowDate = [self makeNSDateFromString:nowString];
    SIVC = [[SignInViewController alloc]init];
    loadingFinish = NO;
    
    if (count30times < 10) {
        [self tickTack:nowDate count:count30times];
        count30times++;
        NSLog(@"sec %i",count30times);
    } else {
        //проверка инета
        if ([self connected]) {
            [self connectWithLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]  password:[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"]];
            count30times = 0;
               //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick60sec:) userInfo:nowDate repeats:YES];
        }else {
             NSLog(@"sec %i",count30times);
            [self tickTack:nowDate count:count30times];
            count30times ++;
        }
        //count30times = 0;
    }
}

- (void) tickTack:(NSDate *) date count:(int)count {
    static NSDateFormatter *dateFormatter;
    if ((count % 2) == 0) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        
        self.timeButton.titleLabel.text = [dateFormatter stringFromDate:date];
    }else {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh mm";
        self.timeButton.titleLabel.text = [dateFormatter stringFromDate:date];
    }
}


//- (void)timerTick60sec:(NSTimer *)timer60  {
//    //NSString *nowString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
//    NSDate *nowDate = [timer60 userInfo];
//    if (count60times < 60) {
//        static NSDateFormatter *dateFormatter;
//        if ((count30times % 2) == 0) {
//            dateFormatter = [[NSDateFormatter alloc] init];
//            dateFormatter.dateFormat = @"hh:mm";
//            
//            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
//        }else {
//            dateFormatter = [[NSDateFormatter alloc] init];
//            dateFormatter.dateFormat = @"hh mm";
//            self.timeButton.titleLabel.text = [dateFormatter stringFromDate:nowDate];
//        }
//        count60times++;
//        NSLog(@"in 60 sec %i", count60times);
//    } else {
//        //[timer60 invalidate];
//       // время + 1 минута
//    }
//}


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

- (void) connectWithLogin:(NSString*)login password:(NSString*)password {
    NSString *urlString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login, password];
    NSLog(@"url %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection)
    {
        mutableData = [[NSMutableData alloc] init];
    }
    
    //return YES;
}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    json = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:nil];
    NSLog(@"json %@", self.json);
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
}


- (IBAction)stopAndStart:(id)sender {
    NSLog(@"Button Pressed!!!");
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
