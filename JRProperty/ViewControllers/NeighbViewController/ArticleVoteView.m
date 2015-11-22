//
//  ArticleVoteView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleVoteView.h"
#import "JRDefine.h"

@implementation ArticleVoteView

#pragma mark 初始化


-(void)initial{
    
    
}
- (IBAction)chooeYes:(id)sender {
//    [self.yesButton setImage:[UIImage imageNamed:@"community_agree_clicked"] forState:UIControlStateDisabled];
//    [self.yesButton setEnabled:NO];
//    [self.noButton setEnabled:NO];
//    int number = [_data.yes intValue]+1;
//     NSString *yesStr = [NSString stringWithFormat:@"   赞成 %d",number];
//    [self.yesButton setTitle:yesStr forState:UIControlStateNormal];
//    [self.yesButton setTitle:yesStr forState:UIControlStateSelected];
//    [self.yesButton setTitle:yesStr forState:UIControlStateDisabled];
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(voteClick:withArticleId:type:)]){
        [_delegate voteClick:self withArticleId:_data.articleId type:@"1"];
    }
}

- (IBAction)chooseNo:(id)sender {
//    [self.noButton setEnabled:NO];
//    [self.yesButton setEnabled:NO];
//    [self.noButton setImage:[UIImage imageNamed:@"community_disagree_clicked"] forState:UIControlStateDisabled];
//    int number = [_data.no intValue]+1;
//    NSString *noStr = [NSString stringWithFormat:@"   反对 %d",number];
//    [self.noButton  setTitle:noStr forState:UIControlStateNormal];
//    [self.noButton  setTitle:noStr forState:UIControlStateSelected];
//    [self.noButton  setTitle:noStr forState:UIControlStateDisabled];
    //调用代理
    if(_delegate && [_delegate respondsToSelector:@selector(voteClick:withArticleId:type:)]){
        [_delegate voteClick:self withArticleId:_data.articleId type:@"0"];
    }
}

- (void)setData:(ArticleDetailModel *)  data {
    _data = data;
    if ([data.voteFlag integerValue] == 1) {
        [self.yesButton setImage:[UIImage imageNamed:@"community_agree_clicked"] forState:UIControlStateDisabled];
        [self.noButton setImage:[UIImage imageNamed:@"disagree_80x80"] forState:UIControlStateDisabled];
        [self.noButton setEnabled:NO];
        [self.yesButton setEnabled:NO];
    }
    else if ( [data.voteFlag integerValue]==2) {
         [self.noButton setImage:[UIImage imageNamed:@"community_disagree_clicked"] forState:UIControlStateDisabled];
        [self.yesButton setImage:[UIImage imageNamed:@"agree_80x80"] forState:UIControlStateDisabled];
        [self.yesButton setEnabled:NO];
        [self.noButton setEnabled:NO];
    }
    else {
        [self.yesButton setEnabled:YES];
        [self.noButton setEnabled:YES];
    }
    NSString *yesStr = [NSString stringWithFormat:@"   赞成 %@",data.yes];
    NSString *noStr = [NSString stringWithFormat:@"   反对 %@",data.no];

    [self.yesButton setTitle:yesStr forState:UIControlStateNormal];
    [self.yesButton setTitle:yesStr forState:UIControlStateSelected];
    [self.yesButton setTitle:yesStr forState:UIControlStateDisabled];
    [self.noButton  setTitle:noStr forState:UIControlStateNormal];
    [self.noButton  setTitle:noStr forState:UIControlStateSelected];
    [self.noButton  setTitle:noStr forState:UIControlStateDisabled];
}
@end
