//
//  CircleListViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  圈子列表页面
//  官方推荐：1   热门社区：2   我的加入的社区:3   我管理的社区：4

#define kOfficialCircle  1
#define kHotCircle       2
#define kMyJoinCircle    3
#define kMyManageCircle  4
#import "JRViewController.h"
#import "JRViewController.h"

@interface CircleListViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *circleListTableView; //tableview
@property (nonatomic ,assign) int circleType; // 圈子类别 1， 2， 3 4
@end
