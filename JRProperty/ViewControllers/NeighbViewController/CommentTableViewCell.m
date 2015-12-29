//
//  CommentTableViewCell.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-27.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIColor+extend.h"
#import "UIImageView+WebCache.h"
#import "JRDefine.h"
#import "JRPropertyUntils.h"
@implementation CommentTableViewCell


-(void)awakeFromNib{
    self.timeLabel.textColor = [UIColor getColor:@"999999"];
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, UIScreenWidth-30, 0)];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor getColor:@"333333"];
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines =0;
    [self addSubview:self.contentLabel];
    self.nameLabel.textColor = [UIColor getColor:@"333333"];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 15;
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick:)];
    [self.headImageView addGestureRecognizer:singleTap];
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
- (void)setData:(CommentModel *)data {
    _data = data;
    self.nameLabel.text = data.nickName;
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGSize labelsize;
    
    if (data.replyNickName.length == 0) {
        self.contentLabel.text = data.content;
        labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.frame = CGRectMake(15, 65, UIScreenWidth-30, labelsize.height);
    }
    else {
        UIFont  *font1 = [UIFont boldSystemFontOfSize:15.0f];
        UIColor  *color1 = [UIColor getColor:@"4a5f8b"];
        NSString *contentStr = [NSString stringWithFormat:@"回复%@:%@",data.replyNickName,data.content];
        NSMutableAttributedString  *tempMutableStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        [tempMutableStr addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(2, data.replyNickName.length)];

        [tempMutableStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(2, data.replyNickName.length)];
        labelsize =[contentStr  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.frame = CGRectMake(15, 65, UIScreenWidth-30, labelsize.height);
        self.contentLabel.attributedText = tempMutableStr;

    }
    if ([data.imageUrl isEqualToString:@"add"]) {
        [JRPropertyUntils refreshUserPortraitInView:self.headImageView];
    }
    else {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data.imageUrl] placeholderImage:[UIImage imageNamed:@"default_portrait_140x140"]];
    }
    if ([data.userLevel isEqualToString:@"1"]) {
        [self.daVip setHidden:NO];
    }
    else {
        [self.daVip setHidden:YES];
    }

    self.timeLabel.text = data.time;
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
+(CGFloat) height:(CommentModel *)data {
    CGFloat cellHeight;
    CGSize size = CGSizeMake(UIScreenWidth-30,4000);
    CGFloat contentHeight =0.0;
    
    if (data.content.length != 0) {
        CGSize labelsize;
        if (data.replyNickName.length == 0) {
            labelsize =[data.content  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        else {
            NSString *contentStr = [NSString stringWithFormat:@"回复%@:%@",data.replyNickName,data.content];
            labelsize =[contentStr  sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        }
        contentHeight = labelsize.height;
    }
    cellHeight = 65+contentHeight+16 ;
    
    return cellHeight;
}

#pragma mark - 头像点击事件
-(void) headClick:(UIImageView *)sender{
    
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(userHeadClick:)]){
        [_delegate userHeadClick:_data.uId];
    }
}


@end
