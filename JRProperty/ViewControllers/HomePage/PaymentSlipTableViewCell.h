//
//  PaymentSlipTableViewCell.h
//  JRProperty
//
//  Created by dw on 14/12/13.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChargeListModel.h"
@interface PaymentSlipTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    // 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;            // 名称
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;           // 价格
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;            // 时间
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;           // 状态
@property (weak, nonatomic) IBOutlet UIImageView *maxLine;          // 长线
@property (weak, nonatomic) IBOutlet UIImageView *minLine;          // 短线
/**
 *  初始化数据
 *
 *  @param chargeModel 账单MODEL
 */
- (void)refrashDataWithChargeModel:(ChargeModel *)chargeModel;
@end
