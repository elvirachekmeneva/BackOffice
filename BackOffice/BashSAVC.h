//
//  BashSAVC.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 05.04.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundVC.h"

@interface BashSAVC : UIViewController {
    BackgroundVC* background;

}

@property (strong, nonatomic) IBOutlet UIImageView *bgrImageView;

@end
