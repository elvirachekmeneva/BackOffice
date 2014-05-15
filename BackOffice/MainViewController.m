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

#import <SystemConfiguration/SystemConfiguration.h>
#import "UIView+TLMotionEffect.h"


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize cameInInfoLabel,changedTimeLabel,json,senderFromSIVC,activityIndicator;
@synthesize showInfo,infoVC;
@synthesize timer1second,timeButton;
@synthesize signIn,SIVC,mutableData,mutableDataWork,connnection,workLog;
@synthesize nameLabel,photo,teamConnection,mutableTeamData,teamInfo,taskDetails,taskActivityIndicator,bgrImage;

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
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    json = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    NSLog(@"Json in MAIN VC %@", [json valueForKey:@"loginSuccess"]);
    
//    [self changeButtonColor];
    
    [self.timeButton addCenterMotionEffectsXYWithOffset:12];
    [self.teamButton addCenterMotionEffectsXYWithOffset:12];
    [self.infoButton addCenterMotionEffectsXYWithOffset:12];
    [self.onlineCountCircle addCenterMotionEffectsXYWithOffset:12];
    [self.onlineCountLabel addCenterMotionEffectsXYWithOffset:12];
    
    [timer1second invalidate];
    
//    self.infoButton.enabled = NO;
//    self.teamButton.enabled = NO;
//    [activityIndicator setAlpha:1];
//    count30times = 30;
//    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
//    [timer1second fire];
    NSLog(@"text text text text text");
    self.SIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskUpdate:)
                                                 name:@"TasksUpdate"
                                               object:nil];
    
    
    
}

- (void) taskUpdate:(NSNotification *) notification {
    [timer1second invalidate];
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
//    [timer1second fire];
    [_tasksTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    json = [[NSUserDefaults standardUserDefaults] objectForKey:@"data"];
    NSLog(@"Json in MAIN VC %@", [json valueForKey:@"loginSuccess"]);
    
    NSURL *imageURL = [NSURL URLWithString:[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"photo"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.photo.image = image;
            self.photo.layer.cornerRadius = 30;
            self.photo.clipsToBounds = YES;
        });
    });
//    [self.timeButton addCenterMotionEffectsXYWithOffset:10];
    
    [self changeButtonColor]; //???
    [self changeLabelText];
    [timer1second invalidate];
    
//    [activityIndicator setAlpha:1];
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
//    [timer1second fire];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (senderFromSIVC == nil) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"switch"] == NO) {
            [self presentViewController:self.SIVC animated:NO completion:nil];
            senderFromSIVC = @"not nil";
        }
        
    }
    
    
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1) {
        background = [[BackgroundVC alloc] initForView:VC_NAME_MAIN_ON];
        [self.toneImage setAlpha:0.6];
    }else {
        background = [[BackgroundVC alloc] initForView:VC_NAME_MAIN_OFF];
        [self.toneImage setAlpha:0];
    }
    
    [self.toneImage setBackgroundColor:[background toneColorForUser:[[NSUserDefaults standardUserDefaults]objectForKey:@"login"]]];
    [self.toneImage setAlpha:0.6];
    
    [self.bgrImage addSubview:background.backGroundImage];
    [self.bgrImage sendSubviewToBack:background.backGroundImage];
    
//    [self.view addCenterMotionEffectsXYWithOffset:40];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)connected {
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        NSLog(@"Device is connected to the internet");
        return YES;
    } else {
        NSLog(@"Device is not connected to the internet");
        return NO;
    }
        
        
//    NSURL *url = [NSURL URLWithString:@"http://google.ru"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    if (data != nil){
//        NSLog(@"Device is connected to the internet");
//        return YES;
//    }else {
//        NSLog(@"Device is not connected to the internet");
//        return NO;
//   }
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
            
            count30times = 0;
        }else {
//            [activityIndicator setAlpha:1];
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
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1) {
        if ((count % 2) == 0) {
            self.timeButton.titleLabel.text = workTime;
        }else {
            
            self.timeButton.titleLabel.text = [workTime stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@" "];
        }
    } else {
        self.timeButton.titleLabel.text = workTime;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    while (json == nil) {
        NSLog(@"Json is nill!!!");
    }
    
    SwipeCellStyle *cell = [tableView dequeueReusableCellWithIdentifier:[SwipeCellStyle cellID]];
    [[SwipeCellStyle alloc] sectionNumber:(int)indexPath.section];
    cell = [[SwipeCellStyle alloc] initWithStyle:UITableViewCellStyleValue1 section:(int)indexPath.section reuseIdentifier:[SwipeCellStyle cellID]];
    
    NSDictionary *currentTask;
    
    if (indexPath.section == 0) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row];
    } else if(indexPath.section == 1) {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row];
    }else {
        currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tasksTable.frame.size.width, 60)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* taskIcon  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 15, 15)];
    NSURL *taskIconURL = [NSURL URLWithString:[currentTask objectForKey:@"typeIcon"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:taskIconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            taskIcon.image = [UIImage imageWithData:imageData];
        });
    });
    [view addSubview:taskIcon];
    
    UILabel *taskPkeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 300, 25)];
    [taskPkeyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    taskPkeyLabel.textAlignment = NSTextAlignmentLeft;
    [taskPkeyLabel setText:[currentTask objectForKey:@"pkey"]];
    [taskPkeyLabel setTextColor:[UIColor whiteColor]];
    [taskPkeyLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:taskPkeyLabel];
    
    UILabel *taskNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, 300, 25)];
    [taskNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    taskNameLabel.textAlignment = NSTextAlignmentLeft;
    [taskNameLabel setText:[currentTask objectForKey:@"summary"]];
    [taskNameLabel setTextColor:[UIColor whiteColor]];
    [taskNameLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:taskNameLabel];
    
    
    [view addCenterMotionEffectsXYWithOffset:12];
    
    [cell.contentView addSubview:view];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    
    
    cell.delegate = self;
    return cell;

}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tasksTable.frame.size.width, 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 300, 39)];
    [sectionNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]];
    sectionNameLabel.textAlignment = NSTextAlignmentLeft;
    [sectionNameLabel setTextColor:[UIColor whiteColor]];
    [sectionNameLabel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* points = [[UIImageView alloc] initWithFrame:CGRectMake(10, 39, self.tasksTable.frame.size.width, 1)];
    [points setImage:[UIImage imageNamed:@"main-points.png"]];
    [view addSubview:points];
    
    UIImageView* taskTypeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 12, 12)];
    
    if (section == 0) {
        [taskTypeIcon setImage:[UIImage imageNamed:@"main-task-work.png"]];
        [view addSubview:taskTypeIcon];
        
        [sectionNameLabel setText:@"В работе"];
        [view addSubview:sectionNameLabel];
        
        return view;
    } else if(section == 1){
        [taskTypeIcon setImage:[UIImage imageNamed:@"main-task-pause.png"]];
        [view addSubview:taskTypeIcon];

        [sectionNameLabel setText:@"Пауза"];
        [view addSubview:sectionNameLabel];
        
        return view;
    } else {
        [taskTypeIcon setImage:[UIImage imageNamed:@"main-task-for-work.png"]];
        [view addSubview:taskTypeIcon];

        [sectionNameLabel setText:@"Задачи для работы"];
        [view addSubview:sectionNameLabel];
        
        return view;
    }

}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"Working";
//    } else if(section == 1){
//        return @"Pause";
//    } else {
//        return @"Assigned";
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *taskID;
    if (indexPath.section == 0) {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row]objectForKey:@"pkey"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row] forKey:@"taskInfoJson"];
    } else if(indexPath.section == 1) {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row]objectForKey:@"pkey"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row] forKey:@"taskInfoJson"];
    }else {
        taskID = [[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row] objectForKey:@"pkey"];
        [[NSUserDefaults standardUserDefaults]setObject:[[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row] forKey:@"taskInfoJson"];
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

#pragma mark - JZSwipeCellDelegate methods

- (void)swipeCell:(JZSwipeCell*)cell triggeredSwipeWithType:(JZSwipeType)swipeType
{
    NSIndexPath *indexPath = [self.tasksTable indexPathForCell:cell];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tasksTable.frame.size.width, 40)];
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    //        [indicator setAlpha:1];
//    indicator.color = [UIColor blueColor];
//    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    
//    [view addSubview:indicator];
    
//    [[self.tasksTable cellForRowAtIndexPath:indexPath].contentView addSubview:view];
    
	if (swipeType != JZSwipeTypeNone)
	{
        [cell.backgroundView setAlpha:1];
		
		if (indexPath)
		{
            if (swipeType == JZSwipeTypeShortRight || swipeType == JZSwipeTypeLongRight) {
                if (indexPath.section == 0) {
                    NSDictionary *currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row];
                    TaskTransactions* taskTrans = [[TaskTransactions alloc] initWithTaskInfoJson:currentTask transitionID:TASK_TRANS_PAUSE];
//                    [taskTrans changeTransitionWithID:TASK_TRANS_PAUSE];
                }else if (indexPath.section == 1) {
                    NSDictionary *currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row];
                    TaskTransactions* taskTrans = [[TaskTransactions alloc] initWithTaskInfoJson:currentTask transitionID:TASK_TRANS_ATWORK];
//                    [taskTrans changeTransitionWithID:TASK_TRANS_ATWORK];
                } else if (indexPath.section == 2) {
                    NSDictionary *currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"assigned"] objectAtIndex:indexPath.row];
                    TaskTransactions* taskTrans = [[TaskTransactions alloc] initWithTaskInfoJson:currentTask transitionID:TASK_TRANS_ATWORK];
//                    [taskTrans changeTransitionWithID:TASK_TRANS_ATWORK];
                }
            }else if (swipeType == JZSwipeTypeShortLeft || swipeType == JZSwipeTypeLongLeft) {
                if (indexPath.section == 0) {
                    NSDictionary *currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"working"] objectAtIndex:indexPath.row];
                    TaskTransactions* taskTrans = [[TaskTransactions alloc] initWithTaskInfoJson:currentTask transitionID:TASK_TRANS_DONE];
//                    [taskTrans changeTransitionWithID:TASK_TRANS_DONE];
                }else if (indexPath.section == 1) {
                    NSDictionary *currentTask = [[[[json objectForKey:@"data"] objectForKey:@"tasks" ] objectForKey:@"pause"] objectAtIndex:indexPath.row];
                    TaskTransactions* taskTrans = [[TaskTransactions alloc] initWithTaskInfoJson:currentTask transitionID:TASK_TRANS_ASSIGN];
//                    [taskTrans changeTransitionWithID:TASK_TRANS_ASSIGN];
                } else if (indexPath.section == 2) {
                    swipeType = JZSwipeTypeNone;
                    [self.tasksTable reloadData];
                }


            }
            
//			[task removeObjectAtIndex:indexPath.row];
//			[self.tasksTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
       
//        [cell.backgroundView addSubview:view];
//        [cell.contentView addSubview:view];
        
        
	}

    
}

- (void)swipeCell:(JZSwipeCell *)cell swipeTypeChangedFrom:(JZSwipeType)from to:(JZSwipeType)to
{
	// perform custom state changes here
	NSLog(@"Swipe Changed From (%d) To (%d)", from, to);
}

#pragma mark - connection methods

- (void) connectWithLogin:(NSString*)login password:(NSString*)password {
   
//    NSString *urlString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login, password];
//    NSLog(@"url %@", urlString);
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
//    [request setHTTPMethod: @"GET"];
//    
//    connnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    if (connnection)
//    {
//        mutableData = [[NSMutableData alloc] init];
//    }
//    
//    NSString *urlTeamString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.online.json.php?json=1&tst=1&dev=1&web=1"];
//    NSURL *urlTeam = [NSURL URLWithString:urlTeamString];
//    NSMutableURLRequest *requestTeam = [NSMutableURLRequest requestWithURL:urlTeam
//                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
//    [requestTeam setHTTPMethod: @"GET"];
//
//    teamConnection = [[NSURLConnection alloc] initWithRequest:requestTeam delegate:self];
//    if (teamConnection)
//    {
//        mutableTeamData = [[NSMutableData alloc] init];
//    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login,password]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && [data length] != 0) {
//            NSError * e;
//            json = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&e];
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDate *loadingDate = [NSDate date];
            //[json setValue:loadingDate forKey:@"loading_date"];
            [[NSUserDefaults standardUserDefaults] setObject:loadingDate forKey:@"loadingDate"];
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"json %@", self.json);
            [activityIndicator setAlpha:0];
            [self changeLabelText];
            [self changeButtonColor];
            [_tasksTable reloadData];
            
        }
        NSDateFormatter *dF = [[NSDateFormatter alloc] init];
        dF.dateFormat = @"yyyy-MM-dd";
        NSDate *today = [NSDate date];
        NSString *todayString = [dF stringFromDate:today];
        NSURL *workLogUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.worklogs.json.php?login=%@&passwrdHash=%@&startDate=%@&endDate=%@",
                                           [[NSUserDefaults standardUserDefaults] objectForKey:@"login"],
                                           [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"],
                                           [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"emplStartDate"],
                                           todayString]];
        NSMutableURLRequest *workLogRequest = [NSMutableURLRequest requestWithURL:workLogUrl
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
        [workLogRequest setURL:workLogUrl];
        [workLogRequest setHTTPMethod: @"GET"];
        NSURLSessionDataTask *workLogTask = [session dataTaskWithRequest:workLogRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error && [data length] != 0) {
                workLog = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"workLog"];
                [[NSUserDefaults standardUserDefaults] setObject:workLog forKey:@"workLog"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self changeLabelText];

            }
            
        }];
        [workLogTask resume];
    }];
    
    [dataTask resume];

    NSURL *urlTeam = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/get.online.json.php?json=1&tst=1&dev=1&web=1"]];
    NSMutableURLRequest *requestTeam = [NSMutableURLRequest requestWithURL:urlTeam
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [requestTeam setHTTPMethod: @"GET"];

    [requestTeam setURL:urlTeam];
    
    NSURLSessionDataTask *teamTask = [session dataTaskWithRequest:requestTeam completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && [data length] != 0) {
            teamInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            TeamInfo* team = [[TeamInfo alloc]initWithDictionary:teamInfo];
            _onlineCountLabel.text = [team onlineCount];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teamInfo"];
            [[NSUserDefaults standardUserDefaults] setObject:teamInfo forKey:@"teamInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self changeLabelText];

        }
        
    }];
    [teamTask resume];
    
}



//- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//    if (connection == connnection){
//        
//        
//    } else if (connection == teamConnection){
//        teamInfo = [NSJSONSerialization JSONObjectWithData:mutableTeamData options:kNilOptions error:nil];
//        TeamInfo* team = [[TeamInfo alloc]initWithDictionary:teamInfo];
//        _onlineCountLabel.text = [team onlineCount];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"teamInfo"];
//        [[NSUserDefaults standardUserDefaults] setObject:teamInfo forKey:@"teamInfo"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    } else {
//        workLog = [NSJSONSerialization JSONObjectWithData:mutableDataWork options:kNilOptions error:nil];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"workLog"];
//        [[NSUserDefaults standardUserDefaults] setObject:workLog forKey:@"workLog"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    
//    
//    [self changeLabelText];
//    [_tasksTable reloadData];
//    [activityIndicator setAlpha:0];
//    
//    self.infoButton.enabled = YES;
//    self.teamButton.enabled = YES;
//    
//}

- (void) changeLabelText {
    int isWork = [[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"isWorking"] integerValue];
    if (isWork == 1){
        NSString* startDate = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"];
        NSString* startTime = [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"];
        startDate = [startDate stringByReplacingOccurrencesOfString:@":" withString:@" "];
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
        [timeButton setAlpha:1];
        [background resetBgrImageForVC:VC_NAME_MAIN_ON];
        [self.toneImage setAlpha:0.6];
    }else {
        [timeButton setAlpha:0.3];
        [background resetBgrImageForVC:VC_NAME_MAIN_OFF];
        [self.toneImage setAlpha:0];
    }
    [self.bgrImage addSubview:background.backGroundImage];
}

- (IBAction)stopAndStart:(id)sender {
    NSLog(@"Button Pressed!!!");
    [timer1second invalidate];
    [activityIndicator setAlpha:1];

    self.timeButton.enabled = NO;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSString* command;
    if ([[[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"endDate"] isEqualToString:@""]) {
        command = @"cmd=off";
        
    } else {
        command = @"cmd=on";
        
    }
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.bossnote.ru/empl/setUserStatus.php?login=%@&passwrdHash=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordMD5"]]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
//    [request setURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error && [data length] != 0) {
            count30times = 30;
            timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDate *loadingDate = [NSDate date];
            //[json setValue:loadingDate forKey:@"loading_date"];
            [[NSUserDefaults standardUserDefaults] setObject:loadingDate forKey:@"loadingDate"];
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"json %@", self.json);
            [activityIndicator setAlpha:0];
//            [self changeLabelText];
            [_tasksTable reloadData];
            [self changeButtonColor];
            self.timeButton.enabled = YES;
        } else {
            self.timeButton.enabled = YES;
        }
        
    }];
    [dataTask resume];

}

- (IBAction)showInfo:(id)sender {
//    self.SIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
//    [self presentViewController:self.SIVC animated:NO completion:nil];
    
}

- (IBAction)showTeam:(id)sender {
//    [self performSegueWithIdentifier:@"teamInfo" sender:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"infoVC"]) {

        InfoViewController* iVC = [segue destinationViewController];
        
    } else if ([[segue identifier] isEqualToString:@"teamInfo"]) {
        TeamViewController* teamVC = [segue destinationViewController];
    }
}


@end
