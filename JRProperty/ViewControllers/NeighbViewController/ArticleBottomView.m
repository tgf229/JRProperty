//
//  ArticleBottomView.m
//  JRProperty
//
//  Created by tingting zuo on 14-11-25.
//  Copyright (c) 2014年 YRYZY. All rights reserved.
//

#import "ArticleBottomView.h"
#import "UIColor+extend.h"
@implementation ArticleBottomView

-(void)initial{
//    [self.priaseButton setTitleColor:[UIColor getColor:@"888888"] forState:UIControlStateNormal];
//    [self.commentButton setTitleColor:[UIColor getColor:@"888888"] forState:UIControlStateNormal];
}

- (void)setData:(ArticleDetailModel *)  data {
    _data = data;
    NSString *praiseStr = [NSString stringWithFormat:@"  %@",data.praiseNum];
    NSString *commentStr = [NSString stringWithFormat:@"  %@",data.commentNum];
    //NSString *shareStr = [NSString stringWithFormat:@"  %@",data.shareNum];

    [self.priaseButton setTitle:praiseStr forState:UIControlStateNormal];
    [self.commentButton setTitle:commentStr forState:UIControlStateNormal];
   // [self.shareButton setTitle:shareStr forState:UIControlStateNormal];
    if ([data.flag integerValue]==1) {
        [self.priaseButton setImage:[UIImage imageNamed:@"linli_detail_footbtn_zan_32x32_press"] forState:UIControlStateNormal];
        [self.priaseButton setImage:[UIImage imageNamed:@"linli_detail_footbtn_zan_32x32"] forState:UIControlStateHighlighted];
        [self.priaseButton removeTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.priaseButton addTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [self.priaseButton setImage:[UIImage imageNamed:@"linli_detail_footbtn_zan_32x32"] forState:UIControlStateNormal];
        [self.priaseButton setImage:[UIImage imageNamed:@"linli_detail_footbtn_zan_32x32_press"] forState:UIControlStateHighlighted];
        [self.priaseButton removeTarget:self action:@selector(cancelPraise) forControlEvents:UIControlEventTouchUpInside];
        [self.priaseButton addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    }
    


}

- (void)praise {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.priaseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.priaseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                   // }];
            }
             ];
        }];
    }];
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        self.priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            self.priaseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
//            
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//            }completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.priaseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
//                        
//                    }];
//            }
//             ];
//        }];
//    }];
    if (_delegate && [_delegate respondsToSelector:@selector(praiseClick:)]) {
        [_delegate praiseClick:_data.articleId];
    }
}
- (void)cancelPraise {
    [UIView animateWithDuration:0.2 animations:^{
        
        _priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _priaseButton.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                _priaseButton.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
//            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    _priaseButton.imageView.transform = CGAffineTransformIdentity;}completion:^(BOOL finished) {
                        
                  //  }];
            }
             ];
        }];
    }];

    if (_delegate && [_delegate respondsToSelector:@selector(cancelPraiseClick:)]) {
        [_delegate cancelPraiseClick:_data.articleId];
    }

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
}
@end
