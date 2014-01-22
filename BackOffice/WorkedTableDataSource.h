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
@property NSDictionary* infoByDay;
@property NSMutableDictionary* allMonthInfo;
@property NSMutableDictionary* infoByMonth;

- (void) initWithDictionary: (NSDictionary*)allData;
@end
