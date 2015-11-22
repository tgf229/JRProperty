//
//  MyMessageViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/26.
//  Copyright (c) 2014 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "BaseModel.h"
@interface MyMessageViewController : JRViewControllerWithBackButton

@property (nonatomic, strong) UITableViewCell *prototypeCell;           // 初始化CELL
@property (weak, nonatomic) IBOutlet UITableView *myMessageTableView;   // 主视图tableView
@property (nonatomic, assign) BOOL messageRequestSuccess;               // 主视图消息请求接口是否有回应
@property (nonatomic, strong) BaseModel * baseModel;                    // MODEL基类
@property (nonatomic, assign) BOOL isNotification;                      // 是否为推送传过来的数据
@end
