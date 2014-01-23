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


NSInteger alphabeticSort(id string1, id string2, void *reverse)
{
    if (*(BOOL *)reverse == YES) {
        return [string2 localizedCaseInsensitiveCompare:string1];
    }
    return [string1 localizedCaseInsensitiveCompare:string2];
}

- (void) initWithDictionary: (NSDictionary*)allData {
    NSString* keyMonth = @"";
    allMonthInfo = [[NSMutableDictionary alloc]init];
    NSDictionary* daysFromJson = [allData objectForKey:@"WORKLOGS"];
 
    NSArray* testArr = [daysFromJson allKeys];
    BOOL reverseSort = NO;
    NSArray* sortedArray = [testArr sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
    
    yearMonthDict = [[NSMutableDictionary alloc]init];
    allMonthInfo = [[NSMutableDictionary alloc]init];
    
    for (NSString* currentDay in sortedArray) {
        //NSString* curDayString = [currentDay substringWithRange:NSMakeRange(0,7)];
        if (![keyMonth isEqualToString:[currentDay substringWithRange:NSMakeRange(0,7)]]) {
            keyMonth = [currentDay substringWithRange:NSMakeRange(0,7)];
            [yearMonthArray addObject:keyMonth];
            //проверка на пустоту объекта с ключом год-месяц
            if (![yearMonthDict objectForKey:keyMonth]) {
                infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
                daysInMonth = [[NSMutableArray alloc]initWithObjects:infoByDay, nil];
                [yearMonthDict setObject:daysInMonth forKey:keyMonth];// = [[NSMutableDictionary alloc]initWithObjectsAndKeys:daysInMonth,keyMonth, nil];
                
            }
            else {
                infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
                [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
            }
            //подсчет з/п за месяц
            infoByMonth = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"],@"workHours",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"],@"loggedHours",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHoursFloat"],@"loggedHoursFloat",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"], @"totalSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"zpSum"],@"zpSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"prSum"],@"prSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"addSum"],@"addSum",
                         [[daysFromJson objectForKey:currentDay] objectForKey:@"coeff"], @"coeff",
                         nil];
            [allMonthInfo setObject:infoByMonth forKey:keyMonth]; //= [[NSMutableDictionary alloc] initWithObjectsAndKeys:infoByMonth,keyMonth, nil];
            
        }else {
            infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
            [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
            
            [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"]
                                       toOldTime:[infoByMonth objectForKey:@"workHours"]] forKey:@"workHours"];
            
            [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"]
                                       toOldTime:[infoByMonth objectForKey:@"loggedHours"]]forKey:@"loggedHours"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"]
                                       toOldSum:[infoByMonth objectForKey:@"totalSum"]] forKey:@"totalSum"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"addSum"]
                                       toOldSum:[infoByMonth objectForKey:@"addSum"]] forKey:@"addSum"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHoursFloat"]
                                       toOldSum:[infoByMonth objectForKey:@"loggedHoursFloat"]]forKey:@"loggedHoursFloat"];
            
            [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"totalHours"]
                                       toOldSum:[infoByMonth objectForKey:@"totalHours"]]forKey:@"totalHours"];
            
            NSInteger logH = [[infoByMonth objectForKey:@"loggedHoursFloat"] integerValue];
            NSInteger totalH = [[infoByMonth objectForKey:@"totalHours"] integerValue];
            NSString *coeff = [NSString stringWithFormat:@"%d",(logH / totalH)];
            [infoByMonth setObject:coeff forKey:@"coeff"];
            [allMonthInfo setObject:infoByMonth forKey:keyMonth];
            
        }
    }
    NSLog(@"Year Month Dictionaty %@", self.yearMonthDict);
    NSLog(@"All Month Info %@", self.allMonthInfo);
    
}

- (NSString*)addTime:(NSString*)timeString toOldTime:(NSString*)oldTimeString {
    NSString *resultTime = oldTimeString;
    NSInteger hours = [[timeString substringWithRange:NSMakeRange(0,[timeString length] - 3)]integerValue];
    NSInteger minutes = [[timeString substringWithRange:NSMakeRange([timeString length] - 2, 2)]integerValue];
    hours = [[oldTimeString substringWithRange:NSMakeRange(0,[oldTimeString length] - 3)]integerValue] + hours;
    minutes = [[oldTimeString substringWithRange:NSMakeRange([oldTimeString length] - 2,2)]integerValue] + minutes;
    NSInteger resultM = minutes % 60;
    NSInteger resultH = hours + (minutes / 60);
    NSString* minutesStr;
    if (resultM < 10) {
        minutesStr = [NSString stringWithFormat:@"0%i",resultM];
    }else {
        minutesStr = [NSString stringWithFormat:@"%i",resultM];
    }
    resultTime = [NSString stringWithFormat:@"%ld:%@", (long)resultH,minutesStr];
    return resultTime;
}

- (NSString*)addSum:(NSString*)newSum toOldSum:(NSString*)oldSum{
    float resultSum = [oldSum floatValue];
    resultSum += [newSum floatValue];
    return [NSString stringWithFormat:@"%f",resultSum];
}

@end
