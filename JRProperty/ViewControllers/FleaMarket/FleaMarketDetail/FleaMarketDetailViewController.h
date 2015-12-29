//
//  FleaMarketDetailViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/12/16.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface FleaMarketDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property(copy,nonatomic) NSString * aid;
@end
