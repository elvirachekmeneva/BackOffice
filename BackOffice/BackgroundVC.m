
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
- (id) initForView:(NSString*) vcName
{
    self = [super init];
    if (self) {
        state = 0;
        frameWidth = [UIScreen mainScreen].bounds.size.width;
        frameHeight = [UIScreen mainScreen].bounds.size.height;
        bgrImage = [vcName isEqual:VC_NAME_MAIN_ON] ? [UIImage imageNamed:@"main-bgr-color.jpg"] :
                    [vcName isEqual:VC_NAME_MAIN_OFF] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
                    [vcName isEqual:VC_NAME_INFO] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
                    [vcName isEqual:VC_NAME_LOGIN] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
                    [vcName isEqual:VC_NAME_PERSON] ? [UIImage imageNamed:@"team-bgr.png"]:
                    [vcName isEqual:VC_NAME_TASK_DETAILS] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
                    [vcName isEqual:VC_NAME_TEAM] ? [UIImage imageNamed:@"team-bgr.png"]: [UIImage imageNamed:@"main-bgr-gray.jpg"];
        self.backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgrImage.size.width*bgrImage.scale, bgrImage.size.height*bgrImage.scale)];
        self.backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
        self.backGroundImage.image = bgrImage;
        NSLog(@"h = %f, w = %f",self.backGroundImage.image.size.height, self.backGroundImage.image.size.width);
        [self bgrAnimation];
//        [self.backGroundImage addCenterMotionEffectsXYWithOffset:100];
    }
    return self;
}

- (void) resetBgrImageForVC:(NSString*) vcName {
    bgrImage = [vcName isEqual:VC_NAME_MAIN_ON] ? [UIImage imageNamed:@"main-bgr-color.jpg"] :
    [vcName isEqual:VC_NAME_MAIN_OFF] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
    [vcName isEqual:VC_NAME_INFO] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
    [vcName isEqual:VC_NAME_LOGIN] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
    [vcName isEqual:VC_NAME_PERSON] ? [UIImage imageNamed:@"team-bgr.png"]:
    [vcName isEqual:VC_NAME_TASK_DETAILS] ? [UIImage imageNamed:@"main-bgr-gray.jpg"]:
    [vcName isEqual:VC_NAME_TEAM] ? [UIImage imageNamed:@"team-bgr.png"]: [UIImage imageNamed:@"main-bgr-gray.jpg"];
    self.backGroundImage.image = bgrImage;

}

- (void) bgrAnimation {
    float imageWidth = bgrImage.size.width*bgrImage.scale;
    float imageHeight = bgrImage.size.height*bgrImage.scale;
    CGFloat newXPos = 0.0;
    CGFloat newYPos = 0.0;
    
    switch (state) {
        case 0:
            newXPos = -imageWidth + frameWidth;
            newYPos = -imageHeight + frameHeight;
            state = 1;
            break;
        case 1:
            newXPos =  0;
            newYPos =  -imageHeight + frameHeight;
            state = 2;
            break;
        case 2:
            newXPos = -imageWidth + frameWidth;
            newYPos = 0;
            state = 3;
            break;
        default:
            newXPos = 0;
            newYPos = 0;
            state = 0;
            break;
    }
    [UIImageView animateWithDuration:60 animations:^{

        self.backGroundImage.frame = CGRectMake(newXPos, newYPos, imageWidth, imageHeight);
    } completion:^(BOOL finished) {
        [self bgrAnimation];
    }];
    
}

- (UIImage*) currentBgr {
    return self.backGroundImage.image;
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

- (UIColor*) toneColorForUser:(NSString*) login {
    NSDictionary* teamDic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"teamInfo"]];
    NSString* department;
    for (NSString* depName in [teamDic allKeys]){
        for (NSDictionary* personInfo in teamDic[depName]) {
            if ([personInfo[@"userLogin"] isEqualToString:login]) {
                department = depName;
            }
        }
    }
    if ([department isEqualToString:@"web"]) {
        return [self webColor];
    } else if ([department isEqualToString:@"tst"]) {
        return [self qaColor];
    }else if ([department isEqualToString:@"dev"]){
        return [self devColor];
    }
    return [self qaColor];
}

- (UIColor*) toneColorForDepartment:(NSString*) depName {
    
    if ([depName isEqualToString:@"web"]) {
        return [self webColor];
    } else if ([depName isEqualToString:@"tst"]) {
        return [self qaColor];
    }else if ([depName isEqualToString:@"dev"]){
        return [self devColor];
    }
    return [self qaColor];
}


- (UIColor*) devColor {
    return [UIColor colorWithHexString:@"d36a2a"];
}

- (UIColor*) webColor {
    return [UIColor colorWithHexString:@"1aa3e4"];
}

- (UIColor*) qaColor {
    return [UIColor colorWithHexString:@"af30ce"];
}

@end
