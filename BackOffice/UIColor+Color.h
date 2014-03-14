//
//  UIColor+Color.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 14.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)hexString;

@end
