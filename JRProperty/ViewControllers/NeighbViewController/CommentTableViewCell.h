//
//  CommentTableViewCell.h
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

@class CommentTableViewCell;
@protocol CommentTableViewCellDelegate <NSObject>
/**
 *  话题发布者 用户头像点击事件
 *
 *  @param userId 用户id
 */
-(void) userHeadClick:(NSString*)userId;
@end
@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shortLine;
@property (weak, nonatomic) IBOutlet UIImageView *longLine;

@property (weak, nonatomic) id<CommentTableViewCellDelegate> delegate; //代理
@property (strong,nonatomic) CommentModel *data;
@property (assign, nonatomic) BOOL   isLast; // 圈子类型
@property (weak, nonatomic) IBOutlet UIButton *daVip;
@property (strong, nonatomic)  UILabel *contentLabel;
- (void)isLastRow:(BOOL)isLast;
+(CGFloat) height:(CommentModel *)data;


- (void)setData:(CommentModel *)data;

@end
