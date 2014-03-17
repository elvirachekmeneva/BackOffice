//
//  TaskTransactions.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwipeCellStyle.h"


#define TASK_TRANS_ATWORK @"11"
#define TASK_TRANS_PAUSE @"41"
#define TASK_TRANS_DONE @"21"
#define TASK_TRANS_ASSIGN @"51"


@interface TaskTransactions : NSObject {
    NSURLConnection *taskTransitionsConnection;
    NSMutableData* mutableTaskTransitionsData;
    
    NSURLConnection *postTransitionConnection;
    NSMutableData* postTransitionsData;
    
    NSDictionary* taskInfoDic;
    NSArray* taskTransitions;
    
    NSString* transactionID;

}

- (id)initWithTaskInfoJson:(NSDictionary*) taskInfo transitionID:(NSString*) transID;
- (void) changeTransitionWithID:(NSString*) transition;

@end
