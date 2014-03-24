//
//  BackgroundVC.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 14.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Color.h"
#import "UIView+TLMotionEffect.h"


#define VC_NAME_LOGIN @"loginVC"
#define VC_NAME_MAIN_ON @"mainVC"
#define VC_NAME_MAIN_OFF @"mainVCOff"
#define VC_NAME_INFO @"infoVC"
#define VC_NAME_TEAM @"teamVC"
#define VC_NAME_PERSON @"personVC"
#define VC_NAME_TASK_DETAILS @"taskDetailsVC"

@interface BackgroundVC : UIViewController {
    UIColor *devColor;
    UIColor *webColor;
    UIColor *qaColor;
    int state;
    int frameWidth;
    int frameHeight;
    UIImage* bgrImage;
    
}

@property UIImageView* backGroundImage;
- (id) initForView:(NSString*) vcName;

- (UIImage*) currentBgr;
- (UIColor*) toneColorForUser:(NSString*) login;
- (UIColor*) toneColorForDepartment:(NSString*) depName;
- (void) resetBgrImageForVC:(NSString*) vcName;
@end
