//
//  ArticleBottom.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleBottom.h"
#import "UIColor+extend.h"
@implementation ArticleBottom


-(void)initial{
    [self.priseButton setTitleColor:[UIColor getColor:@"888888"] forState:UIControlStateNormal];
    [self.commentButton setTitleColor:[UIColor getColor:@"888888"] forState:UIControlStateNormal];
   // [self.shareButton setTitleColor:[UIColor getColor:@"888888"] forState:UIControlStateNormal];
//    [self.priseButton setBackgroundImage:[UIImage imageNamed:@"button_press_bg_40x40"] forState:UIControlStateHighlighted];
//    [self.commentButton setBackgroundImage:[UIImage imageNamed:@"button_press_bg_40x40"] forState:UIControlStateHighlighted];
//    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"button_press_bg_40x40"] forState:UIControlStateHighlighted];
}

- (void)setData:(ArticleDetailModel *)  data {
    _data = data;
    NSString *praiseStr = [NSString stringWithFormat:@"  %@",data.praiseNum];
    NSString *commentStr = [NSString stringWithFormat:@"  %@",data.comment];
   // NSString *shareStr = [NSString stringWithFormat:@"  %@",data.shareNum];
    
    [self.priseButton setTitle:praiseStr forState:UIControlStateNormal];
    [self.commentButton setTitle:commentStr forState:UIControlStateNormal];
    //[self.shareButton setTitle:shareStr forState:UIControlStateNormal];
    if ([data.flag integerValue]==1) {
        [self.priseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateNormal];
        [self.priseButton setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateHighlighted];
        [self.priseButton removeTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.priseButton addTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.priseButton setImage:[UIImage imageNamed:@"like_36x36"] forState:UIControlStateNormal];
        [self.priseButton setImage:[UIImage imageNamed:@"community_like_press"] forState:UIControlStateHighlighted];
        [self.priseButton removeTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
        [self.priseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)praise {
    [UIView animateWithDuration:0.2 animations:^{
        
        _priseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _priseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _priseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _priseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(praiseClick:)]) {
        [_delegate praiseClick:_data.articleId];
    }
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(praiseClick:withSection:)]) {
        [_delegate praiseClick:_data.articleId withSection:_section];
    }
    // dw end
    
}
- (void)cancelPraise {
    [UIView animateWithDuration:0.2 animations:^{
        
        _priseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _priseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _priseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _priseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                    }];
            }
             ];
        }];
    }];

    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraiseClick:)]) {
        [_delegate cancelPraiseClick:_data.articleId];
    }
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraiseClick:withSection:)]) {
        [_delegate cancelPraiseClick:_data.articleId withSection:_section];
    }
    // dw end
}



- (IBAction)commentClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(commentClick:)]) {
        [_delegate commentClick:_data];
    }
}

- (IBAction)shareClick:(id)sender {
   
    if (_delegate && [_delegate respondsToSelector:@selector(shareArticle:)]) {
        [_delegate shareArticle:_data.articleId];
    }
  
    // dw add
    if (_delegate && [_delegate respondsToSelector:@selector(shareArticle:withSection:)]) {
        [_delegate shareArticle:_data.articleId withSection:_section];
    }
    // dw end
}
@end
