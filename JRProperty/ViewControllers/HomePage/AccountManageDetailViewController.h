//
//  AccountManageDetailViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "BillListModel.h"

@interface AccountManageDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableViewCell *prototypeCell;   // 初始CELL
@property (nonatomic, strong) BillModel * billModel;            // 账单MODEL
@property (nonatomic, copy) NSString * typeStr;                 // 类型
@property (weak, nonatomic) IBOutlet UITableView *accountManageDetailTableView; // 账单详情
@property (strong, nonatomic) IBOutlet UIView *tableViewHeadView;   // 主视图头部
@property (weak, nonatomic) IBOutlet UIButton *checkButton;         // 是否显示所有账单按钮
@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;       // 头部标题

@property (strong, nonatomic) NSMutableArray * dataSourceArray;     // 所有数据源
@property (strong, nonatomic) NSMutableArray * noPayDataArray;      // 未缴账单数据源
@end
