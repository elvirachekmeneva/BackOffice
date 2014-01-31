//
//  WorkedTableDataSource.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 22.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    Norm,
    Success,
    Fail
}DaySuccess;

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


- (DaySuccess) successDayByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)commentByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSMutableDictionary*)getInfoByMonth:(NSInteger)monthNumber;
- (NSMutableDictionary*) getInfoByMonth:(NSInteger) monthNumber andDayNumber:(NSInteger)dayNumber;

@end
