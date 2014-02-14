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
//#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize cameInInfoLabel,changedTimeLabel,json,senderFromSIVC,activityIndicator;
@synthesize showInfo,infoVC;
@synthesize timer1second,timeButton;
@synthesize signIn,SIVC,mutableData,mutableDataWork,connnection,workLog;
@synthesize nameLabel,photo,teamConnection,mutableTeamData,teamInfo,taskDetails;

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
    
    [self changeButtonColor];
    
    [self changeLabelText];
    [timer1second invalidate];
    
    self.infoButton.enabled = NO;
    self.teamButton.enabled = NO;
    [activityIndicator setAlpha:1];
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    NSLog(@"text text text text text");
    self.SIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    if (senderFromSIVC == nil) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"switch"] == NO) {
            [self presentViewController:self.SIVC animated:NO completion:nil];
            senderFromSIVC = @"not nil";
        }else {
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            json = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
            NSLog(@"Json in MAIN VC %@", [json valueForKey:@"loginSuccess"]);
            
            
            [self changeButtonColor]; //???
            [self changeLabelText];
            [timer1second invalidate];
            
            [activityIndicator setAlpha:1];
            count30times = 30;
            timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
            NSURL *imageURL = [NSURL URLWithString:[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"photo"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    self.photo.image = [UIImage imageWithData:imageData];
                    self.photo.layer.cornerRadius = 6;
                    self.photo.clipsToBounds = YES;
                });
            });

        }
    }else {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        json = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
        NSLog(@"Json in MAIN VC %@", [json valueForKey:@"loginSuccess"]);
        
        [self changeButtonColor]; //???
        [self changeLabelText];
        [timer1second invalidate];
        
        [activityIndicator setAlpha:1];

        count30times = 30;
        timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    }

}

- (BOOL)connected {
    NSURL *url = [NSURL URLWithString:@"http://google.ru"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != nil){
        NSLog(@"Device is connected to the internet");
        return YES;
    }else {
        NSLog(@"Device is not connected to the internet");
        return NO;
   }
}

- (IBAction)showTeam:(id)sender {
    
}


- (IBAction)exitToSignIn:(id)sender {
    
    self.SIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [self presentViewController:self.SIVC animated:NO completion:nil];
}

- (void)timerTick:(NSTimer *)timer {
    NSString *workedTimeFromJson = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"workedTime"];
    SIVC = [[SignInViewController alloc]init];
    loadingFinish = NO;
    
    if (count30times < 30) {
        [self tickTack:workedTimeFromJson count:count30times];
        count30times++;
        NSLog(@"sec %i",count30times);
    } else {
        //проверка инета
        if ([self connected]) {
            [self connectWithLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]  password:[[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"]];
            [self changeButtonColor];
            //цвета кнопки
//            if ([[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"] isEqualToString:@""]) {
//                [timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
//            }else {
//                [timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
//            }
            
            count30times = 0;
        }else {
            [activityIndicator setAlpha:1];
            NSString * endTimeString = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endTime"];
            
            if ([endTimeString isEqualToString:@""]) {
                NSLog(@"ENDTIME === NIL");
                [self changeButtonColor];
                
                NSTimeInterval intervalBetweenLoadingAndNow = [[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"loadingDate"]];//[json objectForKey:@"loading date"]];
                NSInteger intervalBetweenInInt = intervalBetweenLoadingAndNow;
                
                NSString *hoursString = [workedTimeFromJson substringWithRange:NSMakeRange(0, 2)];
                NSString *minutesString = [workedTimeFromJson substringWithRange:NSMakeRange(3, 2)];
                NSInteger workedTimeInSeconds = [hoursString intValue] *3600 + [minutesString intValue] *60;
                
                NSInteger resultWorkedTime = intervalBetweenInInt + workedTimeInSeconds;
                
                NSInteger resultHours = resultWorkedTime / 3600;
                NSInteger resultMinutes = (resultWorkedTime / 60) % 60;
                
                NSLog(@"result worked time: %ld:%ld",(long)resultHours,(long)resultMinutes);
                NSString* hours = @"";
                NSString* minutes = @"";
                
                //добавление нолика, если в минутах одна цифра
                if (resultHours < 10) {
                    hours = [NSString stringWithFormat:@"0%i",resultHours];
                }else {
                    hours = [NSString stringWithFormat:@"%i",resultHours];
                }
                if (resultMinutes < 10) {
                    minutes = [NSString stringWithFormat:@"0%i",resultMinutes];
                }else {
                    minutes = [NSString stringWithFormat:@"%i",resultMinutes];
                }
                
                
                NSString *workedTime = [NSString stringWithFormat:@"%@:%@",hours,minutes];
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

- (void) tickTack:(NSString*) workTime count:(int)count {
    if ((count % 2) == 0) {
        self.timeButton.titleLabel.text = workTime;
    }else {
        
        self.timeButton.titleLabel.text = [workTime stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@" "];
    }
}



- (NSDate*)makeNSDateFromString:(NSString*)dateString {
    static NSDateFormatter *dateFormatter1;
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
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
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] count];
    } else if(section == 1) {
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] count];
    }else {
        return [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    
//    if (cell == nil) {
    while (json == nil) {
        NSLog(@"Json is nill!!!");
    }
    
      UITableViewCell *  cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
//    }
    
    NSDictionary *currentTask;
    int sec = indexPath.section;
    int rowNum = indexPath.row;
    NSLog(@"%d %d", sec, rowNum);
    if (indexPath.section == 0) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row];
    }else {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row];
    }
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@",[currentTask objectForKey:@"pkey"],[currentTask objectForKey:@"summary"]]];
    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Working";
    } else if(section == 1){
        return @"Pause";
    } else {
        return @"Assigned";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *taskID;
    if (indexPath.section == 0) {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row]objectForKey:@"pkey"];
    } else if(indexPath.section == 1) {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row]objectForKey:@"pkey"];
    }else {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row] objectForKey:@"pkey"];
    }
    [[NSUserDefaults standardUserDefaults]setObject:taskID forKey:@"taskID"];
//    [[NSUserDefaults standardUserDefaults]setObject:[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row] forKey:@"taskInfoJson"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.taskDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDatailsVC"];
    [self presentViewController:self.taskDetails animated:NO completion:nil];
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
    
    connnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connnection)
    {
        mutableData = [[NSMutableData alloc] init];
    }
    
    NSString *urlTeamString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.online.json.php?json=1&tst=1&dev=1&web=1"];
    NSURL *urlTeam = [NSURL URLWithString:urlTeamString];
    NSMutableURLRequest *requestTeam = [NSMutableURLRequest requestWithURL:urlTeam
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [requestTeam setHTTPMethod: @"GET"];
    
    teamConnection = [[NSURLConnection alloc] initWithRequest:requestTeam delegate:self];
    if (teamConnection)
    {
        mutableTeamData = [[NSMutableData alloc] init];
    }


}


-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == connnection){
        [mutableData setLength:0];
    } else if (connection == teamConnection){
        [mutableTeamData setLength:0];
    } else {
        [mutableDataWork setLength:0];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == connnection){
        [mutableData appendData:data];
    } else if (connection == teamConnection) {
        [mutableTeamData appendData:data];
    }else {
        [mutableDataWork appendData:data];
    }

}



- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == connnection){
        json = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:nil];
        //[json setObject:[NSDate date] forKey:@"loading date"];
        NSDate* loadingDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:loadingDate forKey:@"loadingDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"json %@", self.json);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"data"];
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        NSDateFormatter *dF = [[NSDateFormatter alloc] init];
        dF.dateFormat = @"yyyy-MM-dd";
        NSDate *today = [NSDate date];
        NSString *todayString = [dF stringFromDate:today];

        NSString *urlStringWork = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.worklogs.json.php?login=%@&passwrdHash=%@&startDate=%@&endDate=%@",
                                   [[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                                   [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"],
                                   [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"emplStartDate"],
                                   todayString];
        NSLog(@"url %@", urlStringWork);
        NSURL *urlWork = [NSURL URLWithString:urlStringWork];
        NSMutableURLRequest *requestWork = [NSMutableURLRequest requestWithURL:urlWork
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        [requestWork setHTTPMethod: @"GET"];
        
        NSURLConnection *connectionWork = [[NSURLConnection alloc] initWithRequest:requestWork delegate:self];
        if (connectionWork)
        {
            mutableDataWork = [[NSMutableData alloc] init];
        }
        
    } else if (connection == teamConnection){
        teamInfo = [NSJSONSerialization JSONObjectWithData:mutableTeamData options:kNilOptions error:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teamInfo"];
        [[NSUserDefaults standardUserDefaults] setObject:teamInfo forKey:@"teamInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        workLog = [NSJSONSerialization JSONObjectWithData:mutableDataWork options:kNilOptions error:nil];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"workLog"];
        [[NSUserDefaults standardUserDefaults] setObject:workLog forKey:@"workLog"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [self changeLabelText];
    [_tasksTable reloadData];
    [self changeButtonColor];
    [activityIndicator setAlpha:0];
    
    self.infoButton.enabled = YES;
    self.teamButton.enabled = YES;
    
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
    
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@",
                        [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"name"],
                        [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"surname"]]];
}

- (void) changeButtonColor {
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1) {
        [timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
    }else {
        [timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
    }
}

- (IBAction)stopAndStart:(id)sender {
    NSLog(@"Button Pressed!!!");
    [timer1second invalidate];
    [activityIndicator setAlpha:1];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/setUserStatus.php?login=%@&passwrdHash=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"]]];
    NSString* command;
    if ([[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endDate"] isEqualToString:@""]) {
        command = @"cmd=off";
        //[timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];

    } else {
        command = @"cmd=on";
        //[timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];

    }
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    if(conn) {
        NSLog(@"Connection Successful");
    }
    else {
        NSLog(@"Connection could not be made");
    }
    

}

- (IBAction)showInfo:(id)sender {
    showInfo = [[UIStoryboardSegue alloc]initWithIdentifier:@"showInfo" source:self destination:infoVC];
    [self performSegueWithIdentifier:@"showInfo" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showInfo"]) {

        infoVC = [segue destinationViewController];
        
    }
}
@end
