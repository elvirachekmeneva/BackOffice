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
- (id) initWithHeight:(int) height width:(int)width
{
    self = [super init];
    if (self) {
        
        
        
        UIImage* image = [UIImage imageNamed:@"main-bgr-color.jpg"];
        self.backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.backGroundImage.image = image;
        
//        self.backGroundImage.center = self.view.center;
        
        CGRect frameRect = self.backGroundImage.frame;
        CGPoint rectPoint = frameRect.origin;
        CGFloat newXPos = rectPoint.x - 0.9f;
        CGFloat newYPos = rectPoint.y - 0.9f;
        [UIImageView animateWithDuration:5 animations:^{
            self.backGroundImage.frame = CGRectMake(newXPos, newYPos, self.backGroundImage.frame.size.width, self.backGroundImage.frame.size.height);
        }];
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        _backGroundImage = [UIImage imageNamed:@"main-bgr-gray.png"];
//    }
//    return self;
//}

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
