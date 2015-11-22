//
//  HelpInfoForHouseOwnerViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/18.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
@interface HelpInfoForHouseOwnerViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableViewCell *prototypeCell;   // 初始CELL
@property (strong, nonatomic) NSMutableArray *sourceArray;      // TableView 数据源
@property (weak, nonatomic) IBOutlet UITableView *helpInfoTableView;    // 主视图TableView



@end
