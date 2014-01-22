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
    allMonthInfo = [[NSMutableDictionary alloc]init];
    NSDictionary* daysFromJson = [allData objectForKey:@"WORKLOGS"];
    
    for (NSString* currentDay in [daysFromJson allKeys]) {
        if (keyMonth != [currentDay substringWithRange:NSMakeRange(0,7)]) {
            keyMonth = [currentDay substringWithRange:NSMakeRange(0,7)];
            [yearMonthArray addObject:keyMonth];
            //проверка на пустоту объекта с ключом год-месяц
            if (![yearMonthDict objectForKey:keyMonth]) {
                infoByDay = [[NSDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
                daysInMonth = [[NSMutableArray alloc]initWithObjects:infoByDay, nil];
                yearMonthDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:infoByDay,keyMonth, nil];
            }else {
                infoByDay = [[NSDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
                [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
            }
            //подсчет з/п за месяц
            infoByMonth = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"],@"workHours",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"],@"loggedHours",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"], @"totalSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"zpSum"],@"zpSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"prSum"],@"prSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"addSum"],@"addSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"coeff"], @"coeff",
                         nil];
            allMonthInfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:infoByDay,keyMonth, nil];
            
        }else {
            infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
            [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
            
            [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"]
                                       toOldTime:[infoByMonth objectForKey:@"workHours"]] forKey:@"workHours"];
            
            [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"]
                                       toOldTime:[infoByMonth objectForKey:@"loggedHours"]]forKey:@"loggedHours"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"]
                                       toOldSum:[infoByMonth objectForKey:@"totalSum"]] forKey:@"totalSum"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHoursFloat"]
                                       toOldSum:[infoByMonth objectForKey:@"loggedHoursFloat"]]forKey:@"loggedHoursFloat"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"totalHours"]
                                       toOldSum:[infoByMonth objectForKey:@"totalHours"]]forKey:@"totalHours"];
            
            NSInteger logH = [[infoByMonth objectForKey:@"loggedHoursFloat"] integerValue];
            NSInteger totalH = [[infoByMonth objectForKey:@"totalHours"] integerValue];
            NSString *coeff = [NSString stringWithFormat:@"%d",(logH / totalH)];
            [infoByMonth setObject:coeff forKey:@"coeff"];

            
        }
    }
}

- (NSString*)addTime:(NSString*)timeString toOldTime:(NSString*)oldTimeString {
    NSString *resultTime = oldTimeString;
    NSInteger hours = [[timeString substringWithRange:NSMakeRange(0,2)]integerValue];
    NSInteger minutes = [[timeString substringWithRange:NSMakeRange(3, 2)]integerValue];
    hours = [[oldTimeString substringWithRange:NSMakeRange(0,2)]integerValue] + minutes / 60;
    minutes = [[oldTimeString substringWithRange:NSMakeRange(3,2)]integerValue] + minutes % 60;
    resultTime = [NSString stringWithFormat:@"%ld:%ld", (long)hours,(long)minutes];
    return resultTime;
}

- (NSString*)addSum:(NSString*)newSum toOldSum:(NSString*)oldSum{
    NSInteger resultSum = [oldSum integerValue];
    resultSum += [newSum integerValue];
    return [NSString stringWithFormat:@"%ld",(long)resultSum];
}

@end
