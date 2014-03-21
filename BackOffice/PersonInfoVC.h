//
//  PersonInfoVC.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 04.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BackgroundVC.h"

@interface PersonInfoVC : UIViewController <MFMailComposeViewControllerDelegate> {
    NSDictionary* userInfo;
    BackgroundVC* background;
}
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
- (IBAction)callButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIImageView *toneImageView;
- (IBAction)emailButtonPressed:(id)sender;
- (IBAction)saveContact:(id)sender;

@end
