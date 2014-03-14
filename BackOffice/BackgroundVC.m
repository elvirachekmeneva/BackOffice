//
//  BackgroundVC.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 14.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "BackgroundVC.h"

@interface BackgroundVC ()

@end

@implementation BackgroundVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    devColor = [UIColor colorWithHexString:@"d36a2a"];
    webColor = [UIColor colorWithHexString:@"1aa3e4"];
    qaColor = [UIColor colorWithHexString:@"af30ce"];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
