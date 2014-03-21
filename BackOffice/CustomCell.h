//
//  CustomCell.h
//  BackOffice
//
//  Created by Эльвира Чекменева on 03.02.14.
//  Copyright (c) 2014 Эльвира Чекменева. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *onlineTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *onlineStartTime;
@property (strong, nonatomic) IBOutlet UILabel *offlineTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *offlineEndTime;
@property (strong, nonatomic) IBOutlet UILabel *offlineStartTime;


@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIButton *personInfoButton;
@property (strong, nonatomic) IBOutlet UIImageView *onlineIcon;
@property (strong, nonatomic) IBOutlet UIImageView *bgrImage;


@end
