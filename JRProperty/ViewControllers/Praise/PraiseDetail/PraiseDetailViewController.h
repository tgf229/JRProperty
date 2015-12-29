//
//  PraiseDetailViewController.h
//  JRProperty
//
//  Created by YMDQ on 15/11/27.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "JRViewController.h"
#import "PraiseListModel.h"
#import "PraiseDetailListModel.h"

@interface PraiseDetailViewController : JRViewControllerWithBackButton<UITableViewDataSource,UITableViewDelegate,PassPraiseDetailModelDelegate>

@property(strong,nonatomic) PraiseModel * praiseModel; // 接收表扬员工信息
@property(copy,nonatomic) NSString * cTime; // 选择对时间YYYYMM
@property(strong,nonatomic) PraiseDetailModel * detailModel; // 新增的表扬model

@property (weak, nonatomic) IBOutlet UITableView *praiseDetailTableView;

@end
