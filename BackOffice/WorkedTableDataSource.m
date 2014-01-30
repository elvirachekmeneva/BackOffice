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
        return [string1 localizedCaseInsensitiveCompare:string2];
    }
    return [string2 localizedCaseInsensitiveCompare:string1];
}

- (id) initWithDictionary: (NSDictionary*)allData {
    self = [super init];
    
    if (self) {
        NSString* keyMonth = @"";
        allMonthInfo = [[NSMutableDictionary alloc]init];
        NSDictionary* daysFromJson = [allData objectForKey:@"WORKLOGS"];
     
        NSArray* testArr = [daysFromJson allKeys];
        BOOL reverseSort = NO;
        NSArray* sortedArray = [testArr sortedArrayUsingFunction:alphabeticSort context:&reverseSort];
        
        yearMonthArray = [[NSMutableArray alloc]init];
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
//                else {
//                    infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
//                    [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
//                }
                //подсчет з/п за месяц
                infoByMonth = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"],@"workHours",
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"],@"loggedHours",
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"zpSum"],@"zpSum",
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"prSum"],@"prSum",
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"addSum"],@"addSum",
                               [[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"],@"totalSum",
                               nil];
                [allMonthInfo setObject:infoByMonth forKey:keyMonth];
                
            }else {
                infoByDay = [[NSMutableDictionary alloc]initWithDictionary:[daysFromJson objectForKey:currentDay]];
                [[yearMonthDict objectForKey:keyMonth] addObject:infoByDay];
                
                [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"workHours"]
                                           toOldTime:[infoByMonth objectForKey:@"workHours"]] forKey:@"workHours"];
                
                [infoByMonth setObject:[self addTime:[[daysFromJson objectForKey:currentDay] objectForKey:@"loggedHours"]
                                           toOldTime:[infoByMonth objectForKey:@"loggedHours"]]forKey:@"loggedHours"];
                
                [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"totalSum"]
                                           toOldSum:[infoByMonth objectForKey:@"totalSum"]] forKey:@"totalSum"];
                
                [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"zpSum"]
                                           toOldSum:[infoByMonth objectForKey:@"zpSum"]] forKey:@"zpSum"];
                
                [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"prSum"]
                                           toOldSum:[infoByMonth objectForKey:@"prSum"]] forKey:@"prSum"];
                
                [infoByMonth setObject:[self addSum:[[daysFromJson objectForKey:currentDay] objectForKey:@"addSum"]
                                           toOldSum:[infoByMonth objectForKey:@"addSum"]] forKey:@"addSum"];
                
                [allMonthInfo setObject:infoByMonth forKey:keyMonth];

                
                
            }
        }
        NSLog(@"Year Month Dictionaty %@", self.yearMonthDict);
        NSLog(@"All Month Info %@", self.allMonthInfo);
    
    }
    
    return self;
    
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

- (int)countOfMonth {
    return  [yearMonthArray count];
}

- (NSArray*)headerNamesArray {
    return yearMonthArray;
}

- (int) countOfDaysInMonth:(NSString*) monthKey {
    return [[yearMonthDict objectForKey:monthKey]count];
}

- (NSString*) dateStringByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"day"];
    return resultString;
}

- (NSString*) startAndEndTimeByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* startTime = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"startTime"];
    NSString* endTime = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"endTime"];
    NSString* resultString = [NSString stringWithFormat:@"%@ - %@", startTime,endTime];
    return resultString;
}

- (NSString*)workedHoursByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"workHours"];
    return resultString;
}

- (NSString*)addHoursByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"addHours"];
    return resultString;
}

- (NSString*)loggedHoursByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"loggedHours"];
    return resultString;
}

- (NSString*)totalSumByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[NSString alloc] init];
    NSInteger zpSum = [[[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]
                            objectForKey:@"zpSum"] integerValue];
    NSInteger prSum = [[[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]
                            objectForKey:@"prSum"] integerValue];
    NSInteger addSum = [[[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]
                            objectForKey:@"addSum"] integerValue];
    NSInteger resultSum = [[[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]
                            objectForKey:@"totalSum"] integerValue];
    
    
    resultString = [NSString stringWithFormat:@"%ld + %ld + %ld = %ld",(long)zpSum,(long)prSum,(long)addSum,(long)resultSum];
    return resultString;
}


- (NSString*)coeffByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"prCoeff"];
    return resultString;
}

- (NSString*)commentByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    NSString* resultString = [[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"comment"];
    return resultString;
}




- (NSString*)workHoursByMonth:(NSString*)monthString{
    NSString *hoursAndMinutes = [[allMonthInfo objectForKey:monthString]objectForKey:@"workHours"];
    NSString* resultString = [hoursAndMinutes substringWithRange:NSMakeRange(0, [hoursAndMinutes length]-3)];
    return resultString;
}

- (NSString*)loggedHoursByMonth:(NSString*)monthString{
    NSString *hoursAndMinutes = [[allMonthInfo objectForKey:monthString]objectForKey:@"loggedHours"];
    NSString* resultString = [hoursAndMinutes substringWithRange:NSMakeRange(0, [hoursAndMinutes length]-3)];
    return resultString;
}

- (NSString*)totalSumByMonth:(NSString*)monthString{
    NSInteger resSum = [[[allMonthInfo objectForKey:monthString]objectForKey:@"totalSum"] integerValue] * 0.87;
    NSString* resultString = [NSString stringWithFormat:@"%ld",(long)resSum];
    
    return resultString;
}

- (NSString*)okladAndPremSumByMonth:(NSString*)monthString{
    NSInteger zpSum = [[[allMonthInfo objectForKey:monthString]objectForKey:@"zpSum"] integerValue] * 0.87;
    NSInteger prSum = [[[allMonthInfo objectForKey:monthString]objectForKey:@"prSum"] integerValue] * 0.87;
    NSString* resultString = [NSString stringWithFormat:@"%ld",(long)(zpSum + prSum)];
    
    return resultString;
}

- (NSString*)addSumByMonth:(NSString*)monthString{
    NSInteger resSum = [[[allMonthInfo objectForKey:monthString]objectForKey:@"addSum"] integerValue] * 0.87;
    NSString* resultString = [NSString stringWithFormat:@"%ld",(long)resSum];
    
    return resultString;
}

- (DaySuccess) successDayByMonth:(NSString*) monthKey andDayNumber:(NSInteger)dayNumber {
    float coeff = [[[[yearMonthDict valueForKey:monthKey]objectAtIndex:dayNumber]objectForKey:@"prCoeff"] floatValue];
    if (coeff > 1) {
        return Success;
    } else if (coeff < 1){
        return Fail;
    }
    return Norm;
}

@end
