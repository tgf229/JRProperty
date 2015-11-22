//
//  HelpInfoForHouseOwnerViewTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpInfoListModel.h"
@interface HelpInfoForHouseOwnerViewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLineOne;
@property (weak, nonatomic) IBOutlet UILabel *plotNameLabel;    // 名称
@property (weak, nonatomic) IBOutlet UILabel *plotPhoneLabel;   // 电话
@property (weak, nonatomic) IBOutlet UILabel *plotAddressLabel; // 地址
@property (weak, nonatomic) IBOutlet UIButton *plotPhoneButton; // 呼叫按钮
/**
 *  初始化数据
 *
 *  @param helpInfoModel 便民信息MODEL
 */
- (void)refrashDataWithHelpInfoModel:(HelpInfoModel *)helpInfoModel;

@end
