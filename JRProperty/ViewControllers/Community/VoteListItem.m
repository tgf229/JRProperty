//
//  VoteListItem.m
//  JRProperty
//
//  Created by 涂高峰 on 15/12/8.
//  Copyright © 2015年 YRYZY. All rights reserved.
//

#import "VoteListItem.h"
#import "UIColor+extend.h"
#import "JRDefine.h"

@implementation VoteListItem

-(void)initial{
    [self setBackgroundColor:[UIColor getColor:@"f6f6f6"]];
    self.nameLabel.textColor = [UIColor getColor:@"333333"];
    self.numLabel.textColor = [UIColor getColor:@"888888"];
    self.progressView.progressTintColor = [UIColor getColor:@"f25e4f"]; //进度条覆盖颜色
    self.progressView.trackTintColor = [UIColor getColor:@"e0e0e0"];    //进度条底色
}

-(void)setData:(VoteModel *)data totalNum:(int)totalNum{
    _data = data;
    self.nameLabel.text = data.voteName;
    self.numLabel.text = data.voteNum;
    double num = [data.voteNum doubleValue];
    if (num == 0) {
        self.progressView.progress = 0;
    }else{
        self.progressView.progress = num/totalNum;
    }
    if ([@"1" isEqualToString:data.myVote]) {
        [self.choiseImageView setImage:[UIImage imageNamed:@"community_vote_custom_item_press"]];
        self.isChoise = @"1";
    }
}

-(IBAction)voteClick:(id)sender{
    if (![@"1" isEqualToString:self.isChoise]) {
        if (_delegate && [_delegate respondsToSelector:@selector(voteClick:)]) {
            [_delegate voteClick:_data.voteId];
        }
    }
}

@end
