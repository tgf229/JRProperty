//
//  NewReplyTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 15-3-31.
//  Copyright (c) 2015年 YRYZY. All rights reserved.
//

#import "NewReplyTableViewCell.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "LoginManager.h"
#import "JRDefine.h"
@implementation NewReplyTableViewCell

- (void)awakeFromNib {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(57, 0, 100, 15)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor getColor:@"888888"];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.timeLabel];
    self.articleContentLabel.textColor = [UIColor getColor:@"888888"];
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(57, 37, UIScreenWidth-146, 0)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines =0;
    [self addSubview:self.contentLabel];
    self.nameLabel.textColor = [UIColor getColor:@"4a5f88"];
    self.userHead.layer.masksToBounds = YES;
    self.userHead.layer.cornerRadius = 20;
    self.userHead.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    [self.userHead addGestureRecognizer:singleTap];
    [self.shortLine setHidden:YES];
    [self.longLine setHidden:YES];

}

- (void)isLastRow:(BOOL)isLast {
    self.isLast = isLast;
}

/**
 *  填充数据
 *
 *  @param data
 *
 */
- (void)setData:(ReplyModel *)data {
    _data = data;
    self.nameLabel.text = data.replyNickName;
    if ([data.userLevel isEqualToString:@"1"]) {
        [self.daVip setHidden:NO];
    }
    else {
        [self.daVip setHidden:YES];
    }
    CGSize size = CGSizeMake(UIScreenWidth-146,4000);
    CGFloat contentHeight =0.0;
    CGSize labelsize;
    
    if (data.beReplyNickName.length == 0) {
        labelsize =[data.replyContent  sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.text = data.replyContent;
    }
    else {
        UIFont  *font1 = [UIFont boldSystemFontOfSize:12.0f];
        UIColor  *color1 = [UIColor getColor:@"4a5f8b"];
        NSString *contentStr;
        NSMutableAttributedString  *tempMutableStr;
        if ([[LoginManager shareInstance].loginAccountInfo.uId isEqualToString:data.beReplyUId]) {
            contentStr = [NSString stringWithFormat:@"回复我:%@",data.replyContent];
            tempMutableStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [tempMutableStr addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(2, 1)];
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(2, 1)];
        }
        else {
            contentStr = [NSString stringWithFormat:@"回复%@:%@",data.beReplyNickName,data.replyContent];
            tempMutableStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [tempMutableStr addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(2, data.beReplyNickName.length)];
            [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(2, data.beReplyNickName.length)];
        }
        labelsize =[contentStr  sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.attributedText = tempMutableStr;

    }
    contentHeight = labelsize.height;
    self.contentLabel.frame = CGRectMake(64, 37, UIScreenWidth-146, contentHeight);
    self.timeLabel.frame =CGRectMake(64, 37+contentHeight+10, 100, 15);
    
    [self.userHead sd_setImageWithURL:[NSURL URLWithString:data.replyHeadUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    if (data.imageUrl.length !=0) {
         [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"community_default"]];
    }
    else {
        self.articleContentLabel.text = data.content;
    }
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date=[dateformatter dateFromString:data.time];
    NSString *time = [JRPropertyUntils compareCurrentTime:date];
    self.timeLabel.text = time;
    if (self.isLast) {
        [self.longLine setHidden:NO];
        [self.shortLine setHidden:YES];
    }
    else {
        [self.longLine setHidden:YES];
        [self.shortLine setHidden:NO];
    }
}
/**
 *  获取评论区域高度
 *
 *  @param data 评论列表
 *
 *  @return 高度
 */
+(CGFloat) height:(ReplyModel *)data {
    CGFloat cellHeight;
    CGSize size = CGSizeMake(UIScreenWidth-146,4000);
    CGFloat contentHeight =0.0;
    if (data.replyContent.length != 0){
        
        CGSize labelsize;
        if (data.beReplyNickName.length == 0) {
            labelsize =[data.replyContent  sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        else {
            NSString *contentStr = [NSString stringWithFormat:@"回复%@:%@",data.beReplyNickName,data.replyContent];
            labelsize =[contentStr  sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        contentHeight = labelsize.height;

    }
    
    cellHeight = 37+contentHeight+10+15+10;
    
    return cellHeight;
}

#pragma mark - 头像点击事件
-(void) headClick:(UIImageView *)sender{
    
    //调用代理
    //    if(_delegate && [_delegate respondsToSelector:@selector(userHeadClick:)]){
    //        [_delegate userHeadClick:_data.uId];
    //    }
}
@end
