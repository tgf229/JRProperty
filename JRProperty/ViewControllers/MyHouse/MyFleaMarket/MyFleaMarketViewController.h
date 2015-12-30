//
//  MyFleaMarketViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/12/29.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface MyFleaMarketViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate>
@property(copy,nonatomic) NSString * titleName;
@end
