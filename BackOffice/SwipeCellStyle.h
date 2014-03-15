//
//  SwipeCellStyle.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JZSwipeCell.h"

@interface SwipeCellStyle : JZSwipeCell

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *taskActivity;

- (void) setNameText:(NSString*)name;
- (void) showActivity;
+ (NSString*)cellID;

@end
