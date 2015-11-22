//
//  ExpressMessageViewController.h
//  JRProperty
//
//  Created by duwen on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"
@interface ExpressMessageViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *expressMsgTableView;  // 主视图TableView


@end
