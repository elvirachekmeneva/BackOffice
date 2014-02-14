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

@interface WorkedTableDataSource : NSObject {
    NSMutableArray* yearMonthArray;
    NSMutableDictionary* yearMonthDict;
    NSMutableArray* daysInMonth;
    NSMutableDictionary* infoByDay;
    NSMutableDictionary* allMonthInfo;
    NSMutableDictionary* infoByMonth;
}



- (id) initWithDictionary: (NSDictionary*)allData;
- (int)countOfMonth;
- (NSArray*)headerNamesArray;
- (int) countOfDaysInMonth:(NSString*) monthKey;


- (DaySuccess) successDayByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSString*)commentByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber;
- (NSMutableDictionary*)getInfoByMonth:(NSInteger)monthNumber;
- (NSMutableDictionary*) getInfoByMonth:(NSInteger) monthNumber andDayNumber:(NSInteger)dayNumber;

@end
