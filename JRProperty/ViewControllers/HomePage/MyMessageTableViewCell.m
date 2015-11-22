//
//  MyMessageTableViewCell.m
//  JRProperty
//
//  Created by duwen on 14/11/20.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "MyMessageTableViewCell.h"
#import "JRDefine.h"
@implementation MyMessageTableViewCell

- (void)setFrame:(CGRect)frame{
    if (CURRENT_VERSION < 7.0f) {
        frame.origin.x -= 15;
        frame.size.width += 30;
    }
    [super setFrame:frame];
}

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundView:[[UIView alloc] init]];
    [_messageLabel setTextColor:UIColorFromRGB(0x444444)];
    [_timeLabel setTextColor:UIColorFromRGB(0x666666)];
    [_messageNameLabel setTextColor:UIColorFromRGB(0x000000)];
}

- (void)reFrashDataWithMessageModel:(MessageModel *)messageModel{
//    _messageNameLabel.text = messageModel.name?messageModel.name:@"";
    _messageLabel.text = messageModel.content;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:messageModel.time];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    _timeLabel.text = strDate;
    
//    if ([@"1" isEqualToString:messageModel.type] || [@"3" isEqualToString:messageModel.type]) {
//        // 红色
//        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tongzhi"]];
//    }else if ([@"5" isEqualToString:messageModel.type]){
//        // 绿色
//        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_kuaidi"]];
//    }else{
//        // 黄色
//        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tuiguang"]];
//    }
    
    if ([@"1" isEqualToString:messageModel.type]) {
        _messageNameLabel.text = @"通告";
        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tongzhi"]];
    }else if ([@"2" isEqualToString:messageModel.type]){
        _messageNameLabel.text = @"营销推广";
        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tuiguang"]];
    }else if ([@"3" isEqualToString:messageModel.type]){
        _messageNameLabel.text = @"服务信息";
        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tongzhi"]];
    }else if ([@"5" isEqualToString:messageModel.type]){
        _messageNameLabel.text = @"快递";
        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_kuaidi"]];
    }else{
        _messageNameLabel.text = @"其他";
        [_messageIconImageView setImage:[UIImage imageNamed:@"message_icon_tuiguang"]];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
