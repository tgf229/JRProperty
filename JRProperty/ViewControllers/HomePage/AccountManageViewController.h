//
//  AccountManageViewController.h
//  JRProperty
//
//  Created by dw on 14/11/22.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *accountManageTableView; // 主视图

@end
