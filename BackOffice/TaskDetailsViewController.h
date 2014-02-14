//
//  TaskDetailsViewController.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 14.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Autolayout)
+(id)autolayoutView;
@end

@interface TaskDetailsViewController : UIViewController {
    NSDictionary* taskInfoJson;
    NSArray* taskTransitions;
    NSURLConnection* taskTransitionsConnection;
    NSMutableData* mutableTaskTransitionsData;
}
- (IBAction)atWorkButtonPressed:(id)sender;

@end
