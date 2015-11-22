//
//  MySettingTableViewCell.h
//  JRProperty
//
//  Created by liugt on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySettingTableViewCell : UITableViewCell

@property (weak ,nonatomic) IBOutlet UILabel    *titleLabel;                // 标题
@property (weak, nonatomic) IBOutlet UIView     *rightView;                 // 操作按钮

@end
