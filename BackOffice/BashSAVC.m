//
//  BashSAVC.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 05.04.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "BashSAVC.h"

@interface BashSAVC ()

@end

@implementation BashSAVC

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
    [super viewDidLoad];


	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.backItem.title = @" ";

    background = [[BackgroundVC alloc] initForView:VC_NAME_TEAM];
    [self.bgrImageView addSubview:background.backGroundImage];
    [self.bgrImageView sendSubviewToBack:background.backGroundImage];

}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.backItem.title = @" ";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
