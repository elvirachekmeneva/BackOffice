//
//  SwipeCellStyle.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZSwipeCell.h"

@interface SwipeCellStyle : JZSwipeCell{
    
}

@property int currentSectionNumber;

- (void) sectionNumber:(int)section;
+ (NSString*)cellID;

@end
