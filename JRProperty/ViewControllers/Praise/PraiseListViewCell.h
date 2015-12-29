//
//  PraiseListViewCell.h
//  JRProperty
//
//  Created by YMDQ on 15/11/24.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PraiseListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage; // 头像
@property (weak, nonatomic) IBOutlet UILabel *depName; // 部门名称
@property (weak, nonatomic) IBOutlet UILabel *depUserName; // 员工姓名
@property (weak, nonatomic) IBOutlet UILabel *depNum; // 员工工号
@property (weak, nonatomic) IBOutlet UIView *backGroung;
@property (weak, nonatomic) IBOutlet UILabel *praiseNum; // 表扬数量
@property (weak, nonatomic) IBOutlet UIImageView *tipsImg;

@end
