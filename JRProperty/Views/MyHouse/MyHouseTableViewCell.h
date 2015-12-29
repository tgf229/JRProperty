//
//  MyHouseTableViewCell.h
//  JRProperty
//
//  Created by liugt on 14/11/14.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  我的家房屋列表cell

#import <UIKit/UIKit.h>

@interface MyHouseTableViewCell : UITableViewCell

@property (weak ,nonatomic) IBOutlet UILabel       *houseLabel;                // 地址
@property (weak, nonatomic) IBOutlet UIButton      *editButton;                // 操作按钮
@property (weak, nonatomic) IBOutlet UIImageView   *speratorLine;              // 分割线
@property (weak, nonatomic) IBOutlet UIImageView   *arrowImageView;         //右侧箭头
@property (weak, nonatomic) IBOutlet UILabel       *statusLabel;    //状态说明
@property (weak, nonatomic) IBOutlet UIImageView   *statusImageView;    //状态图标

@property (copy, nonatomic) dispatch_block_t    editButtonPressedBlock;      // 编辑状态下


/**
 *  更新分割线leading到父view的距离
 *
 *  @param constant 距离
 */
- (void)updateSperatorLineLeadingConstraint:(NSUInteger)constant;

@end
