//
//  CircularDataTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/12/6.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnounceDetailModel.h"
@interface CircularDataTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL isMyComment;         // 是否为自己的约束
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;    // 头部图片
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        // 标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;        // 时间
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;     // 内容
@property (weak, nonatomic) IBOutlet UIImageView *topLineImageView; // 顶部线
@property (weak, nonatomic) IBOutlet UIImageView *centerLineImageView;  // 中心线
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;  // 底部图片
/**
 *  初始化数据
 *
 *  @param announceCommentModel 通告评论MODEL
 */
- (void)refreshDataWithAnnounceCommentModel:(AnnounceCommentModel *)announceCommentModel;
@end
