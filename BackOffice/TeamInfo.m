//
//  TeamInfo.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 31.01.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TeamInfo.h"

@implementation TeamInfo

@synthesize allTeam,departments,userInfo;

+(TeamInfo *)shared {
    
    static TeamInfo  * instance;
	
	@synchronized(self) {
		if(!instance) {
            instance = [[TeamInfo alloc] init];
        }
    }
    
    return instance;
}

- (id) initWithDictionary: (NSMutableDictionary*)allData {
    self = [super init];
    
    if (self) {
        allTeam = [[NSMutableDictionary alloc]init];
        departments = [[NSMutableArray alloc]initWithArray:[allData allKeys]];
        for (NSString *depKey in [allData allKeys]) {
            //NSLog(@"Department Name %@", depKey);
        
            NSArray *departmentPersonsArray = [allData objectForKey:depKey];
            NSMutableArray* online  = [[NSMutableArray alloc]init];
            NSMutableArray* offline  = [[NSMutableArray alloc]init];
            NSString* depName;
            for (NSDictionary* personInfo in departmentPersonsArray) {
               // NSLog(@"Person Name %@", [personInfo objectForKey:@"firstName"]);
                if ([[personInfo objectForKey:@"status"] isEqualToString:@"1"]) {
                    [online addObject:personInfo];
                }else {
                    [offline addObject:personInfo];
                }
                if (![[personInfo objectForKey:@"userLogin"] isEqualToString:@"na.iline"]) {
                    depName = [personInfo objectForKey:@"departName"];
                }
                
            }
            NSDictionary* department = [[NSDictionary alloc]initWithObjectsAndKeys: online, @"online",
                                        offline, @"offline", depName, @"departmentName", nil];
            [allTeam setObject:department forKey:depKey];
        }
        NSLog(@"allTeam Dictionary %@", allTeam);
        NSLog(@"departments %@",departments);
        
    }
    return self;
}

- (NSArray*) getDepartmentsKeys {
    return departments;
}

- (NSString*)departmentNameByKey:(NSString*)depKey {
    NSString* resultString = [[allTeam objectForKey:depKey]objectForKey:@"departmentName"];
    return resultString;
}

- (NSDictionary*) getAllTeamInfo {
    return allTeam;
}

- (NSString*) onlineCount{
    unsigned int count = 0;
    for (NSString *depKey in allTeam) {
        count += [allTeam[depKey][@"online"] count];
    }
    return [NSString stringWithFormat:@"%d",count];
    
}

- (NSString*) allTeamCount{
    unsigned int count = 0;
    for (NSString *depKey in allTeam) {
        count += [allTeam[depKey][@"online"] count];
        count += [allTeam[depKey][@"offline"] count];
    }
    return [NSString stringWithFormat:@"%d",count];
}

- (NSString*) onlineCountForDepartment:(NSString*) depName{
    unsigned int count = 0;
    count += [allTeam[depName][@"online"] count];
    return [NSString stringWithFormat:@"%d",count];
    
}
- (NSString*) allTeamCountForDepartment:(NSString*) depName{
    unsigned int count = 0;
    count += [allTeam[depName][@"online"] count];
    count += [allTeam[depName][@"offline"] count];
    
    return [NSString stringWithFormat:@"%d",count];
}


@end
