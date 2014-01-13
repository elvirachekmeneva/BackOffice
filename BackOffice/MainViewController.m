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
@synthesize cameInInfoLabel,changedTimeLabel,json;
@synthesize showInfo,infoVC;
@synthesize timer1second,timeButton;
@synthesize SIVC,mutableData;
@synthesize assignedTasks,assignedTasksKeys,pausedTasks,pausedTasksKayes,workingTasks,workingTasksKeys;

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
    
    //цвета кнопки
    if ([[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"] isEqualToString:@""]) {
        [timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
    }else {
        [timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
    }
    
//    assignedTasks = [[NSDictionary alloc] initWithDictionary:[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"]];
//    assignedTasksKeys = [assignedTasks allKeys];
//    pausedTasks = [[NSDictionary alloc] initWithDictionary:[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"]];
//    pausedTasksKayes = [pausedTasks allKeys];
//    workingTasks = [[NSDictionary alloc] initWithDictionary:[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"]];
//    workingTasksKeys = [workingTasks allKeys];
    
    [self changeLabelText];
    
    count30times = 0;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    NSLog(@"text text text text text");
    
    
    
    // Allocate a reachability object
//    Reachability* reach = [Reachability reachabilityWithHostName:@"www.google.com"];
//    [reach startNotifier];
    
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
    NSMutableString *nowString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
    //NSDate * nowDate = [self makeNSDateFromString:nowString];
    SIVC = [[SignInViewController alloc]init];
    loadingFinish = NO;
    
    if (count30times < 10) {
        [self tickTack:nowString count:count30times];
        count30times++;
        NSLog(@"sec %i",count30times);
    } else {
        //проверка инета
        if ([self connected]) {
            [self connectWithLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]  password:[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"]];
            
            //цвета кнопки
            if ([[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"] isEqualToString:@""]) {
                [timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
            }else {
                [timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
            }
            
            count30times = 0;
        }else {
            NSString * endTimeString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"];
            
            if ([endTimeString isEqualToString:@""]) {
                NSLog(@"ENDTIME === NIL");
                //установка зеленого цвета кнопки
                [timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
                [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                [dateFormat setDateStyle:NSDateFormatterMediumStyle];
                [dateFormat setDateFormat:@"yyyy:dd:MMMM HH:mm"];
                //смена года на нынешний
                NSDateFormatter *year = [[NSDateFormatter alloc] init];
                [year setDateFormat:@"yyyy"];
                NSDate *nowYear = [NSDate date];
                NSString *yearString =[year stringFromDate:nowYear];
                
                //вычисление разницы между нынешней датой и датой начала работы
                NSString* startDateFromJson = [[NSString alloc]initWithFormat:@"%@:%@ %@",yearString,
                                               [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"],
                                               [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"]];
                NSDate *startTime = [dateFormat dateFromString:startDateFromJson];
                NSLog(@"start time = %@", [startTime description]);
                
                NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startTime];
                NSInteger intervalInInt = interval;
                NSInteger hoursBetweenDates = interval / 3600;
                NSInteger minutesBetweenDates = (intervalInInt / 60) % 60;
                
                NSString* hours = @"";
                NSString* minutes = @"";
                
                //добавление нолика, если в минутах одна цифра
                if (hoursBetweenDates < 10) {
                    hours = [NSString stringWithFormat:@"0%i",hoursBetweenDates];
                }else {
                    hours = [NSString stringWithFormat:@"%i",hoursBetweenDates];
                }
                if (minutesBetweenDates < 10) {
                    minutes = [NSString stringWithFormat:@"0%i",minutesBetweenDates];
                }else {
                    minutes = [NSString stringWithFormat:@"%i",minutesBetweenDates];
                }
                
                
                NSMutableString *workedTime = [NSMutableString stringWithFormat:@"%@:%@",hours,minutes];
                [self tickTack:workedTime count:count30times];
                NSLog(@"WorkedTime = %@", workedTime);
            }else {
                //установка серого цвета кнопки
                [timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
            }
            count30times ++;

        }
    }
}

- (void) tickTack:(NSMutableString*) workTime count:(int)count {
    if ((count % 2) == 0) {
        self.timeButton.titleLabel.text = workTime;
    }else {
        
        self.timeButton.titleLabel.text = [workTime stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@" "];
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
    if (section == 0) {
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] count];
    } else if(section == 1) {
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] count];
    }else {
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
    }
    
    NSDictionary *currentTask;
    
    if (indexPath.section == 0) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row];
    }else {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row];
    }
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",[currentTask objectForKey:@"pkey"],[currentTask objectForKey:@"summary"]]];
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Assigned";
    } else if(section == 1){
        return @"Pause";
    } else {
        return @"Working";
    }
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
    [_tasksTable reloadData];
    
}

- (void) changeLabelText {
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1){
        NSString* startDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"];
        NSString* startTime = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"];
        //startTime = [startTime stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@" "];
        
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
