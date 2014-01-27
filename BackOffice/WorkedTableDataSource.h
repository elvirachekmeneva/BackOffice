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
- (NSString*) datesArrayByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
@end
