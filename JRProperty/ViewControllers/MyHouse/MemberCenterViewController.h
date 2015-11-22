//
//  MemberCenterViewController.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-12.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
//  我的家主页

#import "JRViewController.h"

@interface MemberCenterViewController : JRViewController

@property (weak,nonatomic)   IBOutlet UITableView  *houseTableview;
@property (strong,nonatomic) NSMutableArray        *houseDataArray;


/**
 *  更新视图，有房屋和无房屋的展示不同
 */
- (void)updateViews;

/**
 *  请求房屋信息
 */
- (void)refreshUserHouseInfo;

@end
