//
//  SwipeCellStyle.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "SwipeCellStyle.h"
#import "UIColor+Color.h"

@implementation SwipeCellStyle

- (id)initWithStyle:(UITableViewCellStyle)style section:(int)currentSectionNumber reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-pause-icon.png"], [UIImage imageNamed:@"main-done-icon.png"], [UIImage imageNamed:@"main-done-icon.png"]);
//        self.colorSet = SwipeCellColorSetMake([UIColor greenColor], [UIColor redColor], [UIColor brownColor], [UIColor orangeColor]);
        
		// set the 4 icons for the 4 swipe types
        if (currentSectionNumber == 0) {
            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-pause.png"], [UIImage imageNamed:@"main-pause.png"], [UIImage imageNamed:@"main-done.png"], [UIImage imageNamed:@"main-done.png"]);
            
            self.colorSet = SwipeCellColorSetMake([UIColor colorWithHexString:@"e3b819"], [UIColor colorWithHexString:@"e3b819"], [UIColor colorWithHexString:@"e3b819"], [UIColor colorWithHexString:@"e3b819"]);
            
        } else if (currentSectionNumber == 1) {
            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-begin.png"], [UIImage imageNamed:@"main-begin.png"], [UIImage imageNamed:@"main-assign.png"], [UIImage imageNamed:@"main-assign.png"]);
            
            self.colorSet = SwipeCellColorSetMake([UIColor colorWithHexString:@"2be29c"], [UIColor colorWithHexString:@"2be29c"], [UIColor colorWithHexString:@"6842b6"], [UIColor colorWithHexString:@"6842b6"]);
            
        } else if (currentSectionNumber == 2) {
            self.imageSet = SwipeCellImageSetMake([UIImage imageNamed:@"main-begin.png"], [UIImage imageNamed:@"main-begin.png"], nil, nil);
            
            self.colorSet = SwipeCellColorSetMake([UIColor colorWithHexString:@"2be29c"], [UIColor colorWithHexString:@"2be29c"], [UIColor clearColor], [UIColor clearColor]);
            
        }
        
    }
    self.defaultBackgroundColor = [UIColor clearColor];
    return self;
}

+ (NSString*)cellID
{
	return @"SwipeCell";
}


- (void) sectionNumber:(int)section {
//    currentSectionNumber = section;
}

@end
