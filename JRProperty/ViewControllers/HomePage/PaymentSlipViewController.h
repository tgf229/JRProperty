//
//  PaymentSlipViewController.h
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentSlipViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic)NSMutableArray *sourceArray;    // 数据源
@property (weak, nonatomic) IBOutlet UITableView *paymentSlipTableView; // 主视图
@property (strong, nonatomic) UITableViewCell *prototypeCell;       // 初始CELL
@end
