//
//  MyWorkOrderListViewController.h
//  JRProperty
//
//  Created by dw on 14/11/17.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface MyWorkOrderListViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *workOrderTableView;   // 滑动TableView主视图

@end 
