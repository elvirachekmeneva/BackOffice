//
//  TaskTransactions.m
//  BackOffice
//
//  Created by Эльвира Чекменева on 15.03.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import "TaskTransactions.h"

@implementation TaskTransactions

- (id)initWithTaskInfoJson:(NSDictionary*) taskInfo {
    self = [super init];
    
    if (self) {
        taskInfoDic = taskInfo;
        NSString* codedString = [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
        NSData* codedData = [codedString dataUsingEncoding:NSUTF8StringEncoding];
        NSString* base64String = [codedData base64EncodedStringWithOptions:0];
        
        NSString *urlTaskTransitionsString = [NSString stringWithFormat:@"http://bt.bossnote.ru/rest/api/latest/issue/%@/transitions/",[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]];
        NSURL *urlTaskTransitions = [NSURL URLWithString:urlTaskTransitionsString];
        NSMutableURLRequest *requestTaskTransitions = [NSMutableURLRequest requestWithURL:urlTaskTransitions
                                                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
        [requestTaskTransitions setValue:[NSString stringWithFormat:@"Basic %@",base64String] forHTTPHeaderField:@"Authorization"];
        [requestTaskTransitions setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [requestTaskTransitions setHTTPMethod: @"GET"];
        
        taskTransitionsConnection = [[NSURLConnection alloc] initWithRequest:requestTaskTransitions delegate:self];
        if (taskTransitionsConnection)
        {
            mutableTaskTransitionsData = [[NSMutableData alloc] init];
        }

    }
    return self;
}


-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == taskTransitionsConnection) {
        [mutableTaskTransitionsData setLength:0];
    } else if (connection == postTransitionConnection) {
        [postTransitionsData setLength:0];
    }

}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == taskTransitionsConnection) {
        [mutableTaskTransitionsData appendData:data];
    } else if (connection == postTransitionConnection) {
        [postTransitionsData appendData:data];
    }

}



- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    if (connection == taskTransitionsConnection){
        NSDictionary* transitions = [NSJSONSerialization JSONObjectWithData:mutableTaskTransitionsData options:kNilOptions error:nil];
        taskTransitions = [[NSArray alloc]initWithArray:[transitions objectForKey:@"transitions"]];
        
    } else if (connection == postTransitionConnection) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TasksUpdate" object:self];
        
    }
}


- (void) changeTransitionWithID:(NSString*) transition {
    NSString* codedString = [NSString stringWithFormat:@"%@:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData* codedData = [codedString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64String = [codedData base64EncodedStringWithOptions:0];
    NSLog(@"string %@, coded string %@", codedString, base64String);
    
    NSDictionary *innerJson = [[NSDictionary alloc]initWithObjectsAndKeys:transition,@"id", nil];
    NSDictionary* jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:innerJson, @"transition", nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString %@", jsonString);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bt.bossnote.ru/rest/api/latest/issue/%@/transitions",[[NSUserDefaults standardUserDefaults] objectForKey:@"taskID"]]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setURL:url];
    [request setValue:[NSString stringWithFormat:@"Basic %@",base64String] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    //    [request setHTTPBody:[command dataUsingEncoding:NSUTF8StringEncoding]];
    postTransitionConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (postTransitionConnection)
    {
        postTransitionsData = [[NSMutableData alloc] init];
    }
    
}
@end
