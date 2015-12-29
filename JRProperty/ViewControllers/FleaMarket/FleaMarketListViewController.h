//
//  FleaMarketListViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/12/16.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface FleaMarketListViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>

@property(copy,nonatomic) NSString * propertyName; // 小区名称

@end
