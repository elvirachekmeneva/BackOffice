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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskUpdate:)
                                                 name:@"TasksUpdate"
                                               object:nil];
    
    
    
}

- (void) taskUpdate:(NSNotification *) notification {
    [timer1second invalidate];
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [_tasksTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    
    [self changeButtonColor]; //???
    [self changeLabelText];
    [timer1second invalidate];
    
    [activityIndicator setAlpha:1];
    count30times = 30;
    timer1second = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
//    background = [[BackgroundVC alloc] initWithHeight:_bgrImage.frame.size.height width:_bgrImage.frame.size.width];
    
//    self.bgrImage.image = [UIImage imageNamed:@"main-bgr-gray.jpg"];//background.backGroundImage.image;

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (senderFromSIVC == nil) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"switch"] == NO) {
            [self presentViewController:self.SIVC animated:NO completion:nil];
            senderFromSIVC = @"not nil";
        }
        
    }
    
    background = [[BackgroundVC alloc] initWithHeight:self.bgrImage.frame.size.height width:self.bgrImage.frame.size.width];
//    UIImage* image = [UIImage imageNamed:@"main-bgr-gray.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[background currentBgr]]; // это работает, но не правильно
    [self.view addSubview:background.backGroundImage];
    [self.view sendSubviewToBack:background.backGroundImage];
//    self.bgrImage.image = background.backGroundImage.image;
    NSLog(@"h = %f, w = %f", self.bgrImage.image.size.height, self.bgrImage.image.size.width);
//    self.bgrImage.contentMode = UIViewContentModeCenter;
    NSLog(@"h = %f, w = %f", self.bgrImage.image.size.height, self.bgrImage.image.size.width);

//    CGRect frameRect = self.bgrImage.frame;
//    CGPoint rectPoint = frameRect.origin;
//    CGFloat newXPos = rectPoint.x - 1000;
//    CGFloat newYPos = rectPoint.y - 1000;
//    
//    [UIImageView animateWithDuration:10 animations:^{
//        self.bgrImage.frame = CGRectMake(newXPos, newYPos, self.bgrImage.frame.size.width, self.bgrImage.frame.size.height);
//    }];
//    self.bgrImage.center = self.view.center;
    
//    [self.bgrImage setImage:[UIImage imageNamed:@"main-bgr-gray.png"]];//background.backGroundImage.image;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    [[SwipeCellStyle alloc] sectionNumber:indexPath.section];
    cell = [[SwipeCellStyle alloc] initWithStyle:UITableViewCellStyleValue1 section:indexPath.section reuseIdentifier:[SwipeCellStyle cellID]];
    
    
    //    UITableViewCell *  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tasksTable.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* taskIcon  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2.5, 20, 20)];
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
    
    
    
    [cell.contentView addSubview:view];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    
    
    cell.delegate = self;
    return cell;

}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tasksTable.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *sectionNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 300, 38)];
    [sectionNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]];
    sectionNameLabel.textAlignment = NSTextAlignmentLeft;
    [sectionNameLabel setTextColor:[UIColor whiteColor]];
    [sectionNameLabel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView* points = [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, self.tasksTable.frame.size.width, 2)];
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
        [timeButton setAlpha:1];
        //[timeButton setBackgroundColor:[UIColor colorWithRed:(180/255) green:(255/255) blue:(175/255) alpha:1]];
    }else {
        [timeButton setAlpha:0.3];
        //[timeButton setBackgroundColor:[UIColor colorWithRed:(170/255) green:(170/255) blue:(170/255) alpha:1]];
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

    } else {
        command = @"cmd=on";

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
    self.SIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoVC"];
    [self presentViewController:self.SIVC animated:NO completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showInfo"]) {

        infoVC = [segue destinationViewController];
        
    }
}
@end
