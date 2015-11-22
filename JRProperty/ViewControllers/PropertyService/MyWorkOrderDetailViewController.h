//
//  MyWorkOrderDetailViewController.h
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
#import "WorkOrderListModel.h"
@interface MyWorkOrderDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) WorkOrderModel * workOrderModel;                  // 工单model
@property (strong, nonatomic)UITableViewCell *prototypeCell;                    // 初始化Cell
@property (weak, nonatomic) IBOutlet UITableView *myWorkOrderDetailTableView;   // TableView主视图

@property (weak, nonatomic) IBOutlet UIView *bottomView;                        // 评价视图
@property (weak, nonatomic) IBOutlet UIImageView *timeLineImageView;            // 时间线图片
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *myUploadImageViewArray;  // 上传图片视图数组
@property (strong, nonatomic) IBOutlet UIView *headView;                        // tableView 头部视图
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;                // 用户头像视图
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;                        // 名字Label
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                        // 时间Label
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;                // 类型图片
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;                     // 内容视图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;  // 头部视图 上传图片高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeightContraint; // 头部视图 上传图片中心线约束



@property (weak, nonatomic) IBOutlet UIButton *commentButton;           // 评论按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewHeightConstraint;  // 底部视图高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint; // 主视图距顶部约束

@end
