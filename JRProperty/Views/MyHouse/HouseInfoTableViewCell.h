//
//  HouseInfoTableViewCell.h
//  JRProperty
//
//  Created by liugt on 14/11/24.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseInfoTableViewCell : UITableViewCell

@property (weak,nonatomic)  IBOutlet  UIImageView    *portraitView;    // 头像
@property (weak,nonatomic)  IBOutlet  UIButton       *levelButton;
@property (weak,nonatomic)  IBOutlet  UILabel        *nickNameLabel;
@property (weak,nonatomic)  IBOutlet  UILabel        *phoneLabel;
@property (weak,nonatomic)  IBOutlet  UIButton       *statuButton;
@property (weak,nonatomic)  IBOutlet  UIImageView    *speratorLine;     // 分割线

@property (strong,nonatomic) dispatch_block_t        statuButtonBlock;  // 冻结或者恢复操作


/**
 *  更新用户级别和状态
 *
 *  @param level  用户级别 "1":业主 "2":住户
 *  @param status 状态    "0":冻结 "1":正常
 *  @param isEdit 编辑状态 YES:编辑 NO:未编辑
 */
- (void)updateUserLevel:(NSString *)level withStatus:(NSString *)status;

/**
 *  展示、编辑状态
 *
 *  @param isEdit 编辑状态 YES:编辑 NO:未编辑
 *  @param status 状态    "0":冻结 "1":正常
 */
- (void)updateUserCellEditView:(BOOL)isEdit withStatus:(NSString *)status;

/**
 *  更新分割线leading到父view的距离
 *
 *  @param constant 距离
 */
- (void)updateSperatorLineLeadingConstraint:(NSUInteger)constant;
@end
