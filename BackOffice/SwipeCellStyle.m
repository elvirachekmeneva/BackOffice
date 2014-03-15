//
//  SwipeCellStyle.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "SwipeCellStyle.h"

@implementation SwipeCellStyle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-done-icon.png"], [UIImage imageNamed:@"main-done-icon.png"]);
        self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
        
		// set the 4 icons for the 4 swipe types
//        if (_currentSectionNumber == 0) {
//            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-done-icon.png"], [UIImage imageNamed:@"main-done-icon.png"]);
//            self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
//        } else if (_currentSectionNumber == 1) {
//            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-begin-icon.png"], [UIImage imageNamed:@"main-begin-icon.png"], [UIImage imageNamed:@"main-assign-icon.png"], [UIImage imageNamed:@"main-assign-icon.png"]);
//            self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
//        } else if (_currentSectionNumber == 2) {
//            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-begin-icon.png"], [UIImage imageNamed:@"main-begin-icon.png"], [UIImage imageNamed:@"main-assign-icon.png"], [UIImage imageNamed:@"main-assign-icon.png"]);
//            self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
//        }
        
    }
    self.defaultBackgroundColor = [UIColor clearColor];
    return self;
}

+ (NSString*)cellID
{
	return @"SwipeCell";
}

- (void) sectionNumber:(int)section {
    _currentSectionNumber = section;
}

@end
