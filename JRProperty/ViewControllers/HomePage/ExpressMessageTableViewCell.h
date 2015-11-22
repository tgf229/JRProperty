//
//  ExpressMessageTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageListModel.h"
@interface ExpressMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;    // 快递logo

@property (weak, nonatomic) IBOutlet UILabel *expressNameLabel;     // 房屋名称
@property (weak, nonatomic) IBOutlet UILabel *expressTimeLabel;     // 时间
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;     // 物流号

@property (weak, nonatomic) IBOutlet UIImageView *tipImageVew;      // 是否领取图片
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;             // 是否领取标示

/**
 *  初始化数据
 *
 *  @param packageModel 邮包MODEL
 */
- (void)refrashDataWithPackageModel:(PackageModel *)packageModel;
@end
