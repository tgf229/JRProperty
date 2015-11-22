//
//  MemberTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-21.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunityModel.h"

@interface MemberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shortLine;
@property (weak, nonatomic) IBOutlet UIImageView *longLine;

@property (weak, nonatomic) IBOutlet UIButton *daVip;
@property (strong, nonatomic) MemberModel  *data; //

@property (assign, nonatomic) BOOL   isLast; //
/**
 *  填出数据
 *
 *  @param data
 */
- (void)setData:(MemberModel *)data;
/**
 *  是否最后一行
 *
 *
 */
- (void)isLastRow:(BOOL)isLast;
@end
