//
//  MemberListViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//  邻里 成员列表页面

#import "JRViewController.h"

@interface MemberListViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic) NSArray *memberList; //成员列表
@property (weak, nonatomic) IBOutlet UITableView *memberTableView;//tableview
@end
