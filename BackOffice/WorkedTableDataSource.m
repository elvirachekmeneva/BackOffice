//
//  WorkedTableDataSource.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 22.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "WorkedTableDataSource.h"

@implementation WorkedTableDataSource

@synthesize yearMonthArray;
@synthesize yearMonthDict;
@synthesize daysInMonth;
@synthesize infoByDay;
@synthesize allMonthInfo;
@synthesize infoByMonth;

- (void) initWithDictionary: (NSDictionary*)allData {
    NSString* keyMonth = @"";
    NSDictionary* daysFromJson = [allData objectForKey:@"WORKLOGS"];
    
    for (NSString* currentDay in [daysFromJson allKeys]) {
        if (keyMonth != [currentDay substringWithRange:NSMakeRange(0,7)]) {
            keyMonth = [currentDay substringWithRange:NSMakeRange(0,7)];
            [yearMonthArray addObject:keyMonth];
            
            if (![yearMonthDict objectForKey:keyMonth]) {
                
            }else {
                
            }
        }else {
            
        }
    }
    
}

@end
