//
//  WorkedTableDataSource.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 22.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkedTableDataSource : NSObject

@property NSMutableArray* yearMonthArray;
@property NSMutableDictionary* yearMonthDict;
@property NSMutableArray* daysInMonth;
@property NSMutableDictionary* infoByDay;
@property NSMutableDictionary* allMonthInfo;
@property NSMutableDictionary* infoByMonth;

- (id) initWithDictionary: (NSDictionary*)allData;
- (int)countOfMonth;
- (NSArray*)headerNamesArray;
- (int) countOfDaysInMonth:(NSString*) monthKey;
- (NSString*) dateStringByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)workedHoursByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)loggedHoursByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)totalSumByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)totalSumByMonth:(NSString*)monthString;
@end
