//
//  MyMessageTableViewCell.h
//  JRProperty
//
//  Created by duwen on 14/11/20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"
@interface MyMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *midLineIV;
@property (weak, nonatomic) IBOutlet UIImageView *footLineIV;


@property (weak, nonatomic) IBOutlet UIImageView *messageIconImageView; // 消息icon
@property (weak, nonatomic) IBOutlet UILabel *messageNameLabel;         // 消息名称

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;             // 消息内容

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                // 消息时间

/**
 *  初始化数据
 *
 *  @param messageModel 消息MODEL
 */
- (void)reFrashDataWithMessageModel:(MessageModel *)messageModel;
@end
