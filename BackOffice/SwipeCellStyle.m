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
		// set the 4 icons for the 4 swipe types
//		self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"hp_dog.png"], [UIImage imageNamed:@"package_toys.png"], [UIImage imageNamed:@"sun.png"], [UIImage imageNamed:@"moon.png"]);
		self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
        
    }
    self.defaultBackgroundColor = [UIColor clearColor];
    return self;
}

+ (NSString*)cellID
{
	return @"SwipeCell";
}

- (void) setNameText:(NSString*) name {
    [self.taskNameLabel setText:name];
}

- (void) showActivity {
    
    [self.taskActivity setAlpha:1];
}


@end
