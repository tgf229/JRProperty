//
//  ArticleVoteView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleVoteView.h"
#import "JRDefine.h"
#import "UIColor+extend.h"

@implementation ArticleVoteView

#pragma mark 初始化


-(void)initial{
    [self.yesButton setImage:[UIImage imageNamed:@"community_agree.png"] forState:UIControlStateNormal];//给button添加image
    self.yesButton.imageEdgeInsets = UIEdgeInsetsMake(-37,0,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
       self.yesButton.titleLabel.font = [UIFont systemFontOfSize:10];//title字体大小
    self.yesButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [self.yesButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    self.yesButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -self.yesButton.titleLabel.bounds.size.width-55, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    self.agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(103, 55, 30, 20)];
    self.agreeLabel.font = [UIFont systemFontOfSize:13];
    self.agreeLabel.textColor = [UIColor getColor:@"666666"];
    self.agreeLabel.text = @"赞成";
    [self addSubview:self.agreeLabel];
    
    [self.noButton setImage:[UIImage imageNamed:@"community_disagree.png"] forState:UIControlStateNormal];//给button添加image
    self.noButton.imageEdgeInsets = UIEdgeInsetsMake(-37,0,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    self.noButton.titleLabel.font = [UIFont systemFontOfSize:10];//title字体大小
    self.noButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [self.noButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    self.noButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -self.noButton.titleLabel.bounds.size.width-55, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    self.disagreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(183, 55, 30, 20)];
    self.disagreeLabel.font = [UIFont systemFontOfSize:13];
    self.disagreeLabel.textColor = [UIColor getColor:@"666666"];
    self.disagreeLabel.text = @"反对";
    [self addSubview:self.disagreeLabel];
}
- (IBAction)chooeYes:(id)sender {
    if (self.voteFlag == nil || [@"0" isEqualToString:self.voteFlag]) {
        NSString *yesNum = [self.yesButton currentTitle];
        NSString *yesChangeNum = [NSString stringWithFormat:@"%d",[yesNum intValue] + 1];
        [self.yesButton setTitle:yesChangeNum forState:UIControlStateNormal];
        if ([@"0" isEqualToString:self.voteFlag]) {
            NSString *noNum = [self.yesButton currentTitle];
            NSString *noChangeNum = [NSString stringWithFormat:@"%d",[noNum intValue] - 1];
            [self.noButton setTitle:noChangeNum forState:UIControlStateNormal];
        }
        self.voteFlag = @"1";
        [self.yesButton setImage:[UIImage imageNamed:@"community_agree_press.png"] forState:UIControlStateNormal];
        [self.noButton setImage:[UIImage imageNamed:@"community_disagree.png"] forState:UIControlStateNormal
         ];
        
        //调用代理
        if(_delegate && [_delegate respondsToSelector:@selector(voteClick:withArticleId:type:voteId:)]){
            [_delegate voteClick:self withArticleId:_data.aId type:@"1" voteId:self.yesId];
        }
    }
    
//    [self.yesButton setImage:[UIImage imageNamed:@"community_agree_clicked"] forState:UIControlStateDisabled];
//    [self.yesButton setEnabled:NO];
//    [self.noButton setEnabled:NO];
//    int number = [_data.yes intValue]+1;
//     NSString *yesStr = [NSString stringWithFormat:@"   赞成 %d",number];
//    [self.yesButton setTitle:yesStr forState:UIControlStateNormal];
//    [self.yesButton setTitle:yesStr forState:UIControlStateSelected];
//    [self.yesButton setTitle:yesStr forState:UIControlStateDisabled];
}

- (IBAction)chooseNo:(id)sender {
    if (self.voteFlag == nil || [@"1" isEqualToString:self.voteFlag]) {
        NSString *noNum = [self.noButton currentTitle];
        NSString *noChangeNum = [NSString stringWithFormat:@"%d",[noNum intValue] + 1];
        [self.noButton setTitle:noChangeNum forState:UIControlStateNormal];
        if ([@"1" isEqualToString:self.voteFlag]) {
            NSString *yesNum = [self.yesButton currentTitle];
            NSString *yesChangeNum = [NSString stringWithFormat:@"%d",[yesNum intValue] - 1];
            [self.yesButton setTitle:yesChangeNum forState:UIControlStateNormal];
        }
        self.voteFlag = @"0";
        [self.noButton setImage:[UIImage imageNamed:@"community_disagree_press.png"] forState:UIControlStateNormal
         ];
        [self.yesButton setImage:[UIImage imageNamed:@"community_agree.png"] forState:UIControlStateNormal];
        
        //调用代理
        if(_delegate && [_delegate respondsToSelector:@selector(voteClick:withArticleId:type:voteId:)]){
            [_delegate voteClick:self withArticleId:_data.aId type:@"0" voteId:self.noId];
        }
    }
//    [self.noButton setEnabled:NO];
//    [self.yesButton setEnabled:NO];
//    [self.noButton setImage:[UIImage imageNamed:@"community_disagree_clicked"] forState:UIControlStateDisabled];
//    int number = [_data.no intValue]+1;
//    NSString *noStr = [NSString stringWithFormat:@"   反对 %d",number];
//    [self.noButton  setTitle:noStr forState:UIControlStateNormal];
//    [self.noButton  setTitle:noStr forState:UIControlStateSelected];
//    [self.noButton  setTitle:noStr forState:UIControlStateDisabled];
    
    
}

- (void)setData:(ArticleDetailModel *)  data {
    _data = data;
    for (VoteModel *model in data.voteList) {
        if ([@"0" isEqualToString:model.voteName]) {
            self.noId = model.voteId;
            [self.noButton setTitle:model.voteNum forState:UIControlStateNormal];
            if ([@"1" isEqualToString:model.myVote]) {
                self.voteFlag = @"0";
                [self.noButton setImage:[UIImage imageNamed:@"community_disagree_press.png"] forState:UIControlStateNormal];
            }
        }else if([@"1" isEqualToString:model.voteName]){
            self.yesId = model.voteId;
            [self.yesButton setTitle:model.voteNum forState:UIControlStateNormal];
            if ([@"1" isEqualToString:model.myVote]) {
                self.voteFlag = @"1";
                [self.yesButton setImage:[UIImage imageNamed:@"community_agree_press.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    
//    self.zanchengLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, UIScreenWidth-30, 0)];
//    self.contentLabel.backgroundColor = [UIColor clearColor];
//    self.contentLabel.font = [UIFont systemFontOfSize:15];
//    self.contentLabel.textColor = [UIColor getColor:@"333333"];
//    self.contentLabel.userInteractionEnabled = YES;
//    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.contentLabel.numberOfLines =0;
//    [self addSubview:self.contentLabel];

//    [self.yesButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 20, 0.0)];
//    [self.yesButton setTitle:@"1" forState: UIControlStateNormal];
//    [self.yesButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    
//    if ([data.voteFlag integerValue] == 1) {
//        [self.yesButton setImage:[UIImage imageNamed:@"community_agree_press"] forState:UIControlStateDisabled];
//        [self.noButton setImage:[UIImage imageNamed:@"community_disagree"] forState:UIControlStateDisabled];
//        [self.noButton setEnabled:NO];
//        [self.yesButton setEnabled:NO];
//    }
//    else if ( [data.voteFlag integerValue]==2) {
//         [self.noButton setImage:[UIImage imageNamed:@"community_disagree_press"] forState:UIControlStateDisabled];
//        [self.yesButton setImage:[UIImage imageNamed:@"community_agree"] forState:UIControlStateDisabled];
//        [self.yesButton setEnabled:NO];
//        [self.noButton setEnabled:NO];
//    }
//    else {
//        [self.yesButton setEnabled:YES];
//        [self.noButton setEnabled:YES];
//    }
//    NSString *yesStr = [NSString stringWithFormat:@"   赞成 %@",data.yes];
//    NSString *noStr = [NSString stringWithFormat:@"   反对 %@",data.no];
//
//    [self.yesButton setTitle:yesStr forState:UIControlStateNormal];
//    [self.yesButton setTitle:yesStr forState:UIControlStateSelected];
//    [self.yesButton setTitle:yesStr forState:UIControlStateDisabled];
//    [self.noButton  setTitle:noStr forState:UIControlStateNormal];
//    [self.noButton  setTitle:noStr forState:UIControlStateSelected];
//    [self.noButton  setTitle:noStr forState:UIControlStateDisabled];
}
@end
