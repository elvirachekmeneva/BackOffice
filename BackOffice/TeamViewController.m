//
//  TeamViewController.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 17.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didTapCallButton:(UIButton*)button {
    UIAlertView *allert = [[UIAlertView alloc] initWithTitle:@"You can't call" message:@"Phone number doesn't exist yet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [allert show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"cell"];
    }
    
    UIButton* phone = [UIButton buttonWithType:UIButtonTypeCustom];
    [phone setImage:[UIImage imageNamed:@"phone1.png"] forState:UIControlStateNormal];
    phone.frame = CGRectMake(0, 0, 15, 15);
    phone.userInteractionEnabled = YES;
    [phone addTarget:self action:@selector(didTapCallButton:) forControlEvents:UIControlEventTouchDown];
    cell.accessoryView = phone;
    
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if (indexPath.section == 0) {
        [[cell textLabel]setText:@"I'm here!"];
    } else {
         [[cell textLabel]setText:@"I'm home..."];
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Online";
    } else {
        return @"Offline";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

@end
