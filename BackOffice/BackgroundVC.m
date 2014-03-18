
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
        NSLog(@"h = %f, w = %f",image.size.height, image.size.width);
        self.backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.backGroundImage.contentMode = UIViewContentModeCenter;
        self.backGroundImage.image = image;
        NSLog(@"h = %f, w = %f",self.backGroundImage.image.size.height, self.backGroundImage.image.size.width);
        
//        animationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(bgrAnimation:) userInfo:nil repeats:YES];
        CGRect frameRect = self.backGroundImage.frame;
        CGPoint rectPoint = frameRect.origin;
        CGFloat newXPos = rectPoint.x - 100;
        CGFloat newYPos = rectPoint.y - 100;
        
        [UIImageView animateWithDuration:10 animations:^{
            self.backGroundImage.frame = CGRectMake(newXPos, newYPos, self.backGroundImage.frame.size.width, self.backGroundImage.frame.size.height);
//            self.backGroundImage
        }];
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        UIImage* image = [UIImage imageNamed:@"main-bgr-color.jpg"];
//        self.backGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, super.view.frame.size.width, super.view.frame.size.height)];
//        self.backGroundImage.image = image;
//        self.backGroundImage.contentMode = UIViewContentModeTopLeft;
//
//        animationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(bgrAnimation:) userInfo:nil repeats:YES];
//    }
//    return self;
//}

- (void) bgrAnimation: (NSTimer*) timer {
    CGRect frameRect = self.backGroundImage.frame;
    CGPoint rectPoint = frameRect.origin;
    CGFloat newXPos = rectPoint.x - 1000;
    CGFloat newYPos = rectPoint.y - 1000;
    
    [UIImageView animateWithDuration:10 animations:^{
        self.backGroundImage.frame = CGRectMake(newXPos, newYPos, self.backGroundImage.frame.size.width, self.backGroundImage.frame.size.height);
    }];
    
}

- (UIImage*) currentBgr {
    return self.backGroundImage.image;
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
