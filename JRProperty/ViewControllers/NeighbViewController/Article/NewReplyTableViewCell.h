//
//  NewReplyTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 15-3-31.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyListModel.h"
#import "JRPropertyUntils.h"

@interface NewReplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *contentLabel;

@property (strong, nonatomic)  UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shortLine;
@property (weak, nonatomic) IBOutlet UIImageView *longLine;
@property (weak, nonatomic) IBOutlet UILabel *articleContentLabel;
@property (strong,nonatomic) ReplyModel *data;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UIButton *daVip;
@property (assign, nonatomic) BOOL   isLast; // 圈子类型
- (void)isLastRow:(BOOL)isLast;
+(CGFloat) height:(ReplyModel *)data;


- (void)setData:(ReplyModel *)data;
@end
