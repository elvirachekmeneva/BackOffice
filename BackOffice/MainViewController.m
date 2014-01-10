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
//#import "NSDate.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize cameInInfoLabel,changedTimeLabel,json;
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
    
    [self changeLabelText];
    
//    NSDate* fireDate = [[NSDate alloc]init];
//    fireDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"];
    
    count30times = 0;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    NSLog(@"text text text text text");
    
    
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
        // Here we set up a NSNotification observer. The Reachability that caused the notification
    // is passed in the object parameter

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
    
    [reach startNotifier];
    
	// Do any additional setup after loading the view.
}

- (BOOL)connected {
    NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != nil){
        NSLog(@"Device is connected to the internet");
        return YES;
    }else {
        NSLog(@"Device is not connected to the internet");
        return NO;
   }
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
        }else {
            NSString * endTimeString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"];
            if ([endTimeString isEqualToString:@""]) {
                NSLog(@"ENDTIME === NIL");
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
                [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                [dateFormat setDateStyle:NSDateFormatterMediumStyle];
                [dateFormat setDateFormat:@"yyyy:dd:MMMM HH:mm"];
                
                NSDateFormatter *year = [[NSDateFormatter alloc] init];
                [year setDateFormat:@"yyyy"];
                NSDate *nowYear = [NSDate date];
                NSString *yearString =[year stringFromDate:nowYear];
                
                NSString* startDateFromJson = [[NSString alloc]initWithFormat:@"%@:%@ %@",yearString,
                                               [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"],
                                               [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"]];
                NSDate *startTime = [dateFormat dateFromString:startDateFromJson];
                NSLog(@"start time = %@", [startTime description]);
                
                // []//[NSTimeInterval timeIntervalSinceDate:startTime];
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startTime];
                
                int secondsInAnHour = 3600;
                NSInteger hoursBetweenDates = interval / secondsInAnHour;
                NSInteger intervalInInt = interval;
                NSInteger minutesBetweenDates = (intervalInInt % secondsInAnHour) / 60;
                
                NSLog(@"hoursBetweenDates: %i:%i", hoursBetweenDates, minutesBetweenDates);
            }
            
            [self tickTack:nowDate count:count30times];
            count30times ++;

        }
    }
}

- (void) tickTack:(NSDate *) date count:(int)count {
    static NSDateFormatter *dateFormatter;
    if ((count % 2) == 0) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        
        self.timeButton.titleLabel.text = [dateFormatter stringFromDate:date];
    }else {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH mm";
        self.timeButton.titleLabel.text = [dateFormatter stringFromDate:date];
    }
}

- (NSDate*)makeNSDateFromString:(NSString*)dateString {
    static NSDateFormatter *dateFormatter1;
    if (!dateFormatter1) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = @"HH:mm";
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"data"];
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self changeLabelText];
    
}

- (void) changeLabelText {
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1){
        NSString* startDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"];
        NSString* startTime = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"];
        
        NSString* timeLabelText = [[NSString alloc]initWithFormat:@"%@ %@", startDate, startTime];
        [changedTimeLabel setText:timeLabelText];
    }else {
        NSString* endDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endDate"];
        NSString* endTime = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"];
        
        NSString* timeLabelText = [[NSString alloc]initWithFormat:@"%@ %@", endDate, endTime];
        [changedTimeLabel setText:timeLabelText];
    }
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
