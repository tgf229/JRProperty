//
//  SelectedPlotsTableViewCell.h
//  JRProperty
//
//  Created by dw on 15/3/27.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPlotsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityNameLab;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@end
