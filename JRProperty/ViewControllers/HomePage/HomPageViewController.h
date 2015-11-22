//
//  HomPageViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "EScrollerView.h"
@interface HomPageViewController : JRViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,EScrollerViewDelegate>

@property (strong, nonatomic) EScrollerView *adScrollerView;    // 轮播通告视图
@property (strong, nonatomic) NSMutableArray *adArray;          // 轮播通告Model数据源
@property (strong, nonatomic) NSMutableArray *plotSomeingArray; // 新鲜事儿数据源
@property (weak, nonatomic) IBOutlet UITableView *mainRefreshTableView; // 主视图
@property (strong, nonatomic) UITableViewCell *prototypeCell;   // 初始化Cell
@property (strong, nonatomic) IBOutlet UIView *headView;        // 头部视图

@property (strong, nonatomic) IBOutlet UIView *tableViewSectionCustomView;  // 表视图section视图

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *headViewButtonArray; // 头部视图按钮数组
@property (weak, nonatomic) IBOutlet UIView *headViewExpressButtonView; // 快递数量视图
@property (weak, nonatomic) IBOutlet UILabel *headViewExpressMessageNumLabel;   // 快递数量
@property (weak, nonatomic) IBOutlet UIView *headViewMyMessageButtonView;   // 我的消息数量视图
@property (weak, nonatomic) IBOutlet UILabel *headViewMyMessageNumLabel;    // 我的消息数量




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint; // 主视图距顶部约束

//@property (nonatomic,strong) EScrollerView *headView;


@end
