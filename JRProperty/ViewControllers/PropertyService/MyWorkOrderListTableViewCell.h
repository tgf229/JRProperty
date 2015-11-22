//
//  MyWorkOrderListTableViewCell.h
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOrderListModel.h"

@interface MyWorkOrderListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;        // 类型图片
@property (weak, nonatomic) IBOutlet UILabel *workOrderNumberLabel;     // 工单号
@property (weak, nonatomic) IBOutlet UIImageView *stausImageView;       // 审核状态图片
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;               // 审核状态


@property (weak, nonatomic) IBOutlet UILabel *workOrderInfoLabel;       // 工单内容

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                // 工单时间
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;        // 客服头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;                // 客服姓名

/**
 *  初始化数据
 *
 *  @param workOrderModel 工单Model
 */
- (void)refrashDataWithWorkOrderModel:(WorkOrderModel *)workOrderModel;

@end
