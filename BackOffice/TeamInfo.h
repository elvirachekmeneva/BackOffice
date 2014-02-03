//
//  TeamInfo.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 31.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamInfo : NSObject
@property NSMutableDictionary* allTeam;
@property NSMutableArray* departments;
@property NSMutableDictionary* userInfo;

- (id) initWithDictionary: (NSMutableDictionary*)allData;
- (NSArray*) getDepartmentsKeys;
- (NSString*)departmentNameByKey:(NSString*)depKey;

@end
