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
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *autorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;

- (void) button1Clicked:(id) sender;

- (void) button2Clicked:(id) sender;

- (void) button3Clicked:(id) sender;

- (void) button4Clicked:(id) sender;

@end
