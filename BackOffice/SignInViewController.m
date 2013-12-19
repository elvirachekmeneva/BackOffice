//
//  ViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.12.13.
//  Copyright (c) 2013 Эльвира Чекменева. All rights reserved.
//

#import "SignInViewController.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5)
- (NSString*)MD5
{
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
@synthesize userLogin, userPassword,connection;
@synthesize login,password;
@synthesize saveOrNot;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //загрузка состояния UISwitch
    [super viewWillAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    BOOL test= [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    NSLog(@"%@",test?@"YES":@"NO");
    [self.saveOrNot setOn:test animated:YES];
    
    
    //загрузка логина и пароля из .plist при включенном UISwith
    if (self.saveOrNot.on == YES){
        NSDictionary *userLoginAndPass = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle]
                                                                    pathForResource:@"login_password" ofType:@"plist"]];
        NSString *log = [userLoginAndPass objectForKey:@"login"];
        NSString *pas = [userLoginAndPass objectForKey:@"password"];
        NSLog(@"login: %@, password: %@", log,pas);
        [userLogin setText:log];
        [userPassword setText:pas];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)signInButtonPressed:(id)sender {
    login = [[NSString alloc]initWithString:[userLogin text]];
    password = [[NSString alloc]initWithString:[userPassword text]];
    
    NSString *urlString = [NSString stringWithFormat:@"http://m.bossnote.ru/empl/getUserData.php?login=%@&passwrdHash=%@",login,[password MD5]];
    NSLog(@"url %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (requestError) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error:%@",requestError] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        NSLog(@"ERROR!!!!!!!!");
    }else {
        NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:response
                                                                    options:kNilOptions error:&requestError];
        NSLog(@"json %@", json);
    }
    
    if (self.saveOrNot.on == YES){
        NSMutableDictionary *userLoginAndPass = [[NSMutableDictionary alloc]init];
        [userLoginAndPass setObject:login forKey:@"login"];
        [userLoginAndPass setObject:password forKey:@"password"];
        [userLoginAndPass writeToFile:@"login_password.plist" atomically:YES];
        
    }
    
    
    
}

- (IBAction)saveValueChenged:(id)sender {
    //сохранение состояния UISwitch
    [[NSUserDefaults standardUserDefaults] setBool:self.saveOrNot.on forKey:@"switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
