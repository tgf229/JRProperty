//
//  AccountManageDetailTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillListModel.h"

@interface AccountManageDetailTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataSourceArray;          // 数据源
@property (nonatomic, strong) UITableView *payTableView;        // 主视图
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        // 名称
@property (weak, nonatomic) IBOutlet UILabel *noPayLabel;       // 未缴金额
@property (weak, nonatomic) IBOutlet UILabel *havePayLabel;     // 已缴金额
@property (weak, nonatomic) IBOutlet UIButton *goPayButton;     // 去付款按钮
@property (weak, nonatomic) IBOutlet UILabel *goPayButtonTitleLabel;    // 去付款标题
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;          // 背景底图
@property (weak, nonatomic) IBOutlet UIView *historyPaymentView;        // 历史缴费视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *historyPaymentConstraint; // 历史缴费约束

/**
 *  初始化数据
 *
 *  @param feeModel 缴费账单MODEL
 */
- (void)refrashAccountManageDetailDataWithFeeModel:(FeeModel *)feeModel;
@end
