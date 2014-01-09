//
//  ViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import "SignInViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "MainViewController.h"

@implementation NSString(MD5)
- (NSString*)MD5 {
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

@end

@interface SignInViewController ()

@end

@implementation SignInViewController
@synthesize userLogin, userPassword,signInButton, invalidLabel,activityIndicator;
@synthesize login,password;
@synthesize saveOrNot;
@synthesize mutableData,json;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (self.saveOrNot.on == YES){
        [self loadData];
    }
    [activityIndicator setAlpha:0];
    
   /*
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setDateFormat:@"dd:MMM HH:mm"];
    //NSDate *now = [NSDate date];
    
    NSString* startDateFromJson = [[NSString alloc]initWithFormat:@"%@ %@",
                                   [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startDate"],
                                   [[[json objectForKey:@"data"] objectForKey:@"user" ] objectForKey:@"startTime"]];
    //@"9:Jan 14:01";//[dateFormat stringFromDate:now];
    NSLog(@"now time %@", startDateFromJson);
    
    NSDate *startTime = [dateFormat dateFromString:startDateFromJson];
    NSLog(@"start time = %@", [startTime description]);
    */
    
}

- (void)viewDidAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    //загрузка состояния UISwitch
    BOOL test= [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    NSLog(@"%@",test?@"YES":@"NO");
    [self.saveOrNot setOn:test animated:YES];
    
    
    //загрузка логина и пароля из .plist при включенном UISwith
    if (self.saveOrNot.on == YES){
        [self loadData];
    }else {
        [userPassword setText:@""];
    }
    [invalidLabel setAlpha:0];
    [activityIndicator setAlpha:0];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//получение адреса файла
- (NSString*)getFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0]stringByAppendingPathComponent:@"login_password.plist"];
}

//сохранение логина и пароля в .plist
- (void) saveLogin:(NSString*)login andPassword:(NSString*)password {
    NSArray *value = [[NSArray alloc] initWithObjects:login,password, nil];
    [value writeToFile:[self getFilePath] atomically:YES];
}

//загрузка логина и пароля из .plist прямо в textField'ы
- (void) loadData {
    NSString* myPath = [self getFilePath];
    bool fileExist = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
    if (fileExist) {
        NSArray* values = [[NSArray alloc]initWithContentsOfFile:myPath];
        [userLogin setText:[values objectAtIndex:0]];
        [userPassword setText:[values objectAtIndex:1]];
    }
}

- (void) connectWithLogin:(NSString*)login password:(NSString*)password {
    NSString *urlString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login,[password MD5]];
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

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // If we get any connection error we can manage it here…
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Network Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alertView show];
    [activityIndicator setAlpha:0];
    return;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    json = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:nil];
    NSLog(@"json %@", self.json);
    [activityIndicator setAlpha:0];
    if ([[json objectForKey:@"loginSuccess"] integerValue] == 1) {
        if (self.saveOrNot.on == YES){
            [self saveLogin:login andPassword:password];
        }
        [invalidLabel setAlpha:0];
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"SignIn" sender:nil];
        
    }else {
        [invalidLabel setAlpha:1];
        [userPassword setText:@""];
    }
    
    //[NSJSONSerialization JSONObjectWithData:response
                                                                //options:kNilOptions error:&requestError];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SignIn"]) {
        
        // Get destination view
        MainViewController *mainVC = [segue destinationViewController];
        
        // Pass the information to your destination view
//        [mainVC setJson:json];
    }
}

- (IBAction)signInButtonPressed:(id)sender {
    login = [[NSString alloc]initWithString:[userLogin text]];
    password = [[NSString alloc]initWithString:[userPassword text]];
    
    [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:[password MD5] forKey:@"passwordMD5"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [activityIndicator setAlpha:1];
    [self connectWithLogin:login password:password];
    
   
}

- (IBAction)saveValueChenged:(id)sender {
    //сохранение состояния UISwitch
    [[NSUserDefaults standardUserDefaults] setBool:self.saveOrNot.on forKey:@"switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
