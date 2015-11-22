//
//  CircleListTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-19.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//
#define kMyManageCircle  4
#import <UIKit/UIKit.h>
#import "SquareModel.h"

@interface CircleListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shortLine;
@property (weak, nonatomic) IBOutlet UIImageView *longLine;
@property (strong, nonatomic) CircleInfoModel  *data; // 圈子信息
@property (assign, nonatomic) NSInteger   circleType; // 圈子类型
@property (assign, nonatomic) BOOL   isLast; // 圈子类型
/**
 *  填出数据
 *
 *  @param data 圈子信息
 */
- (void)setData:(CircleInfoModel *)data;
/**
 *  设置类型 我的圈子要特殊处理
 *
 *  @param type 4 我的管理
 */
-(void) setType:(NSInteger )type;
- (void)isLastRow:(BOOL)isLast;
@end
