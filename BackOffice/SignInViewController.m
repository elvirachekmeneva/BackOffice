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
@synthesize userLogin, userPassword,signInButton, invalidLabel,activityIndicator,mainVC;
@synthesize login,password;
@synthesize saveOrNot;
@synthesize mutableData,json;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if (self.saveOrNot.on == YES){
        [self loadData];
    }
   // [activityIndicator setAlpha:0];
   //self.mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self.signInButton setTitle:@"ВХОД" forState:UIControlStateNormal];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //[super viewWillAppear:animated];
    
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
//    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Untitled-1.png"]];
//    self.view.backgroundColor = background;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // dismiss the keyboard
    
    [super touchesBegan:touches withEvent:event];
}

//получение адреса файла
- (NSString*)getFilePath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathArray objectAtIndex:0]stringByAppendingPathComponent:@"login_password.plist"];
}

//сохранение логина и пароля в .plist
- (void) saveLogin:(NSString*)loginn andPassword:(NSString*)passsword {
    NSArray *value = [[NSArray alloc] initWithObjects:loginn,passsword, nil];
    [value writeToFile:[self getFilePath] atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:loginn forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] setObject:passsword forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:[passsword MD5] forKey:@"passwordMD5"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//загрузка логина и пароля из .plist прямо в textField'ы
- (void) loadData {
    [userLogin setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]];
    [userPassword setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
//    NSString* myPath = [self getFilePath];
//    bool fileExist = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
//    if (fileExist) {
//        NSArray* values = [[NSArray alloc]initWithContentsOfFile:myPath];
//        [userLogin setText:[values objectAtIndex:0]];
//        [userPassword setText:[values objectAtIndex:1]];
//    }
}

- (void) connectWithLogin:(NSString*)loginn password:(NSString*)passsword {
    NSString *urlString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",loginn,[passsword MD5]];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Ошибка подключения"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alertView show];
    [activityIndicator setAlpha:0];
    [self.signInButton setTitle:@"ВХОД" forState:UIControlStateNormal];
    return;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    json = [NSJSONSerialization JSONObjectWithData:mutableData options:kNilOptions error:nil];
    NSDate *loadingDate = [NSDate date];
    //[json setValue:loadingDate forKey:@"loading_date"];
    [[NSUserDefaults standardUserDefaults] setObject:loadingDate forKey:@"loadingDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"json %@", self.json);
    [activityIndicator setAlpha:0];
    if ([[json objectForKey:@"loginSuccess"] integerValue] == 1) {
        if (self.saveOrNot.on == YES){
            [self saveLogin:login andPassword:password];
        }
        [invalidLabel setAlpha:0];
        [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:[password MD5] forKey:@"passwordMD5"];
        [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [invalidLabel setAlpha:1];
        [userPassword setText:@""];
    }
    
}



- (IBAction)signInButtonPressed:(id)sender {
    [self.signInButton setTitle:@"" forState:UIControlStateNormal];
    login = [[NSString alloc]initWithString:[userLogin text]];
    password = [[NSString alloc]initWithString:[userPassword text]];
    [activityIndicator setAlpha:1];
    [self connectWithLogin:login password:password];
    
   
}

- (IBAction)saveValueChenged:(id)sender {
    //сохранение состояния UISwitch
    [[NSUserDefaults standardUserDefaults] setBool:self.saveOrNot.on forKey:@"switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.saveOrNot.on) {
        [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:[password MD5] forKey:@"passwordMD5"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == userLogin){
        login = textField.text;
    }else if(textField == userPassword) {
        password = textField.text;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == userLogin) {
        [userPassword  setText:@""];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passwordMD5"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == userLogin) {
        [textField resignFirstResponder];
        [userPassword becomeFirstResponder];
    } else if (textField == userPassword) {
        [self signInButtonPressed:nil];
        
    }
    return YES;
}


@end
