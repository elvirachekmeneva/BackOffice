//
//  TaskDetailsViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 14.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface TaskDetailsViewController ()

@end

@implementation UIView (Autolayout)
+(id)autolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}
@end

@implementation TaskDetailsViewController
@synthesize summaryLabel,typeIcon,statusLabel,typeLabel,autorNameLabel,workerNameLabel,updateLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [self.view addSubview:naviBarObj];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
    
//    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]];
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Описание задачи"];
    navigItem.leftBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
    
    
    
    taskInfoJson = [[NSUserDefaults standardUserDefaults] objectForKey:@"taskInfoJson"];
    
    
    NSString* codedString = [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData* codedData = [codedString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64String = [codedData base64EncodedStringWithOptions:0];

    NSString *urlTaskTransitionsString = [NSString stringWithFormat:@"http://bt.bossnote.ru/rest/api/latest/issue/%@/transitions/",[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]];
    NSURL *urlTaskTransitions = [NSURL URLWithString:urlTaskTransitionsString];
    NSMutableURLRequest *requestTaskTransitions = [NSMutableURLRequest requestWithURL:urlTaskTransitions
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [requestTaskTransitions setValue:[NSString stringWithFormat:@"Basic %@",base64String] forHTTPHeaderField:@"Authorization"];
    [requestTaskTransitions setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [requestTaskTransitions setHTTPMethod: @"GET"];
    
    taskTransitionsConnection = [[NSURLConnection alloc] initWithRequest:requestTaskTransitions delegate:self];
    if (taskTransitionsConnection)
    {
        mutableTaskTransitionsData = [[NSMutableData alloc] init];
    }

    //заполнение полей информации о задачe
    NSURL *typeIconURL = [NSURL URLWithString:[taskInfoJson objectForKey:@"typeIcon"]];
    NSLog(@"%@",typeIconURL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:typeIconURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.typeIcon.image = [UIImage imageWithData:imageData];
        });
    });
    
    [summaryLabel setText:[taskInfoJson objectForKey:@"summary"]];
    [statusLabel setText:[taskInfoJson objectForKey:@"statusName"]];
    [typeLabel setText:[taskInfoJson objectForKey:@"typeName"]];
    [updateLabel setText:[taskInfoJson objectForKey:@"updated"]];
    
    // ищем имя автора задачи по логину
    NSString* autorFirsAndLastName = @"";
    NSArray* depNames = [[[NSUserDefaults standardUserDefaults]objectForKey:@"teamInfo"] allKeys];
    for (NSString* depName in depNames){
        for (NSDictionary* department in [[[NSUserDefaults standardUserDefaults]objectForKey:@"teamInfo"]objectForKey:depName]){
            if ([[department objectForKey:@"userLogin"] isEqualToString:[taskInfoJson objectForKey:@"reporter"]]) {
                autorFirsAndLastName = [NSString stringWithFormat:@"%@ %@",[department objectForKey:@"firstName"],[department objectForKey:@"lastName"]];
            }
        }
    }
    //если не нашли пишем логин
    if ([autorFirsAndLastName isEqualToString:@""]) {
        autorFirsAndLastName = [taskInfoJson objectForKey:@"reporter"];
    }
    [autorNameLabel setText:autorFirsAndLastName];
    
    //ищем имя исполнителя
    NSString* workerFirsAndLastName = @"";
    for (NSString* depName in depNames){
        for (NSDictionary* department in [[[NSUserDefaults standardUserDefaults]objectForKey:@"teamInfo"]objectForKey:depName]){
            if ([[department objectForKey:@"userLogin"] isEqualToString:[taskInfoJson objectForKey:@"assinee"]]) {
                workerFirsAndLastName = [NSString stringWithFormat:@"%@ %@",[department objectForKey:@"firstName"],[department objectForKey:@"lastName"]];
            }
        }
    }
    //если не нашли, то снова выдаем логин
    if ([workerFirsAndLastName isEqualToString:@""]){
        workerFirsAndLastName = [taskInfoJson objectForKey:@"assinee"];
    }
    
    [workerNameLabel setText:workerFirsAndLastName];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cancelButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
}



//- (IBAction)atWorkButtonPressed:(id)sender {
//    NSString* codedString = [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
//    NSData* codedData = [codedString dataUsingEncoding:NSUTF8StringEncoding];
//    NSString* base64String = [codedData base64EncodedStringWithOptions:0];
//    NSLog(@"string %@, coded string %@", codedString, base64String);
//    
//    NSDictionary *innerJson = [[NSDictionary alloc]initWithObjectsAndKeys:@"11",@"id", nil];
//    NSDictionary* jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:innerJson, @"transition", nil];
//    NSError *error;
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"jsonString %@", jsonString);
//    
//    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bt.bossnote.ru/rest/api/latest/issue/%@/transitions",[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]]];
//
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    [request setURL:url];
//    [request setValue:[NSString stringWithFormat:@"Basic %@",base64String] forHTTPHeaderField:@"Authorization"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:jsonData];
////    [request setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
//    NSURLConnection *postTransitionConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
//
//}

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == taskTransitionsConnection) {
        [mutableTaskTransitionsData setLength:0];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == taskTransitionsConnection) {
        [mutableTaskTransitionsData appendData:data];
    }
}



- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == taskTransitionsConnection){
        NSDictionary* transitions = [NSJSONSerialization JSONObjectWithData:mutableTaskTransitionsData options:kNilOptions error:nil];
        taskTransitions = [[NSArray alloc]initWithArray:[transitions objectForKey:@"transitions"]];
    }
    [self createButtonsByTransitions:taskTransitions];
}

- (void) createButtonsByTransitions:(NSArray*) transitionsArray {
    UIView *headerView = [UIView autolayoutView];
    headerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerView];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.translatesAutoresizingMaskIntoConstraints = NO;
//    [button1 setTitle:@"Button" forState:UIControlStateNormal];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.translatesAutoresizingMaskIntoConstraints = NO;
    //    [button1 setTitle:@"Button" forState:UIControlStateNormal];
    
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.translatesAutoresizingMaskIntoConstraints = NO;
    //    [button1 setTitle:@"Button" forState:UIControlStateNormal];
    
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button4.translatesAutoresizingMaskIntoConstraints = NO;
    //    [button1 setTitle:@"Button" forState:UIControlStateNormal];
   
    
    NSDictionary *metrics = @{@"buttonHeigh":@30.0, @"padding":@15.0};
    int count = [transitionsArray count];
    switch (count) {
        case 1: {
            [button1 setTitle:[[transitionsArray objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button1];
            NSDictionary *views = NSDictionaryOfVariableBindings(headerView, button1);
            
            // Header view fills the width of its superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:metrics views:views]];
            
            // Header view is pinned to the top of the superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView(==60.0)]|" options:0 metrics:metrics views:views]];
            
            // Headline and image horizontal layout
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-padding-[button1]-padding-|" options:0 metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            
            [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        }
        case 2:{
            [button1 setTitle:[[transitionsArray objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
            [button1.titleLabel setTextAlignment:NSTextAlignmentRight];
            [headerView addSubview:button1];
            [button2 setTitle:[[transitionsArray objectAtIndex:1] objectForKey:@"name"] forState:UIControlStateNormal];
            [button2.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [headerView addSubview:button2];
            NSDictionary *views = NSDictionaryOfVariableBindings(headerView, button1, button2);
            // Header view fills the width of its superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:metrics views:views]];
            
            // Header view is pinned to the top of the superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView(==60.0)]|" options:0 metrics:metrics views:views]];
            
            // Headline and image horizontal layout
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button1]-[button2(==button1)]-padding-|" options:0 metrics:metrics views:views]];
            
            // Headline and byline vertical layout - spacing at least zero between the two
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button2(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            
            [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];

            break;
        }
        case 3:{
            [button1 setTitle:[[transitionsArray objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button1];
            [button2 setTitle:[[transitionsArray objectAtIndex:1] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button2];
            [button3 setTitle:[[transitionsArray objectAtIndex:2] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button3];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(headerView, button1, button2, button3);
            
            // Header view fills the width of its superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:metrics views:views]];
            
            // Header view is pinned to the top of the superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView(==60.0)]|" options:0 metrics:metrics views:views]];
            
            // Headline and image horizontal layout
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button1]-[button2(==button1)]-[button3(==button1)]-padding-|" options:0 metrics:metrics views:views]];
            
            // Headline and byline vertical layout - spacing at least zero between the two
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button2(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button3(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            
            [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
            

            break;
        }
        case 4:{
            [button1 setTitle:[[transitionsArray objectAtIndex:0] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button1];
            [button2 setTitle:[[transitionsArray objectAtIndex:1] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button2];
            [button3 setTitle:[[transitionsArray objectAtIndex:2] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button3];
            [button4 setTitle:[[transitionsArray objectAtIndex:3] objectForKey:@"name"] forState:UIControlStateNormal];
            [headerView addSubview:button4];
            NSDictionary *views = NSDictionaryOfVariableBindings(headerView, button1, button2, button3, button4);
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[headerView]|" options:0 metrics:metrics views:views]];
            
            // Header view is pinned to the top of the superview
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView(==90.0)]|" options:0 metrics:metrics views:views]];
            
            // Headline and image horizontal layout
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button1]-[button2(==button1)]-padding-|" options:0 metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button3]-[button4(==button3)]-padding-|" options:0 metrics:metrics views:views]];
            
            // Headline and byline vertical layout - spacing at least zero between the two
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1(==buttonHeigh)]-[button3(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button2(==buttonHeigh)]-[button4(==buttonHeigh)]-padding-|" options:NSLayoutFormatAlignAllLeft metrics:metrics views:views]];
            
            [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button4 addTarget:self action:@selector(button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
}

- (void) button1Clicked:(id) sender {
    [self changeTransitionWithID:[[taskTransitions objectAtIndex:0] objectForKey:@"id"]];
}

- (void) button2Clicked:(id) sender {
    [self changeTransitionWithID:[[taskTransitions objectAtIndex:1] objectForKey:@"id"]];
}

- (void) button3Clicked:(id) sender {
    [self changeTransitionWithID:[[taskTransitions objectAtIndex:2] objectForKey:@"id"]];
}

- (void) button4Clicked:(id) sender {
    [self changeTransitionWithID:[[taskTransitions objectAtIndex:3] objectForKey:@"id"]];
}

- (void) changeTransitionWithID:(NSString*) transition {
    NSString* codedString = [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData* codedData = [codedString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64String = [codedData base64EncodedStringWithOptions:0];
    NSLog(@"string %@, coded string %@", codedString, base64String);
    
    NSDictionary *innerJson = [[NSDictionary alloc]initWithObjectsAndKeys:transition,@"id", nil];
    NSDictionary* jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:innerJson, @"transition", nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString %@", jsonString);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bt.bossnote.ru/rest/api/latest/issue/%@/transitions",[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setURL:url];
    [request setValue:[NSString stringWithFormat:@"Basic %@",base64String] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    //    [request setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *postTransitionConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
   [self dismissViewControllerAnimated:YES completion:nil];

}
@end
