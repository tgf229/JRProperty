//
//  PraiseRankingViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/11/25.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"

@interface PraiseRankingViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property(copy,nonatomic) NSString * rankingTime; //  YYYYMM
@end
